import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'connection_provider.dart';
import 'full_sync_service.dart';
import 'nsd_client.dart';
import 'notification_service.dart';
import '../crypto/crypto_service.dart';
import '../database/database.dart';
import '../database/database_provider.dart';

const _localPort = 7890;
const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  HttpServer? _localServer;
  Timer? _serverPollTimer;
  String? _deviceId;
  String? _partnerDeviceId;
  String? _serverUrl;
  WidgetRef? _ref;
  bool _started = false;

  final Map<String, String> _localPeers = {};

  Future<void> start(WidgetRef ref, String serverUrl) async {
    if (_started) return;
    _started = true;

    _ref = ref;
    _serverUrl = serverUrl;
    _deviceId = await _storage.read(key: 'refugium_device_id');
    _partnerDeviceId = await _storage.read(key: 'refugium_partner_device_id');

    if (_deviceId == null) return;

    await _startLocalServer();
    await _startMdnsDiscovery();
    _startServerPolling();
  }

  Future<void> stop() async {
    _serverPollTimer?.cancel();
    _serverPollTimer = null;
    await _localServer?.close(force: true);
    _localServer = null;
    _started = false;
  }

  Future<void> sendSyncEvent({
    required String recipientDeviceId,
    required String messageType,
    required Map<String, dynamic> payload,
  }) async {
    final plainJson = jsonEncode(payload);
    final encryptedPayload = await CryptoService.encrypt(
      plainJson,
      recipientDeviceId,
    );

    if (_localPeers.containsKey(recipientDeviceId)) {
      final address = _localPeers[recipientDeviceId]!;
      try {
        final response = await http
            .post(
              Uri.parse('http://$address/sync'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'sender_device_id': _deviceId,
                'message_type': messageType,
                'payload': encryptedPayload,
              }),
            )
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) return;
      } catch (_) {
        _localPeers.remove(recipientDeviceId);
      }
    }

    if (_serverUrl != null && _deviceId != null) {
      try {
        final client = ApiClient(baseUrl: _serverUrl!);
        await client.sendMessage(
          senderDeviceId: _deviceId!,
          recipientDeviceId: recipientDeviceId,
          payload: encryptedPayload,
          messageType: messageType,
        );
      } catch (_) {}
    }
  }

  /// FullSync als verschlüsselte Nachricht senden
  Future<void> sendFullSyncToRecipient(
    String recipientDeviceId,
    Map<String, dynamic> payload,
  ) async {
    await sendSyncEvent(
      recipientDeviceId: recipientDeviceId,
      messageType: 'FullSync',
      payload: payload,
    );
  }

  void _startServerPolling() {
    _serverPollTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _pollServer(),
    );
    Future.delayed(const Duration(seconds: 2), _pollServer);
  }

  Future<void> _pollServer() async {
    if (_serverUrl == null || _deviceId == null) return;

    _partnerDeviceId = await _storage.read(key: 'refugium_partner_device_id');

    try {
      final client = ApiClient(baseUrl: _serverUrl!);
      final messages = await client.fetchMessages(_deviceId!);

      for (final message in messages) {
        final messageType = message['message_type'] as String?;
        final payload = message['payload'] as String?;
        final senderDeviceId = message['sender_device_id'] as String?;

        if (messageType == null || payload == null) continue;

        if (senderDeviceId != null) {
          await _updatePendingConnection(senderDeviceId);
        }

        await _handleIncomingEvent(messageType, payload, senderDeviceId);
      }
    } catch (_) {}

    // Ausstehende FullSync-Payloads senden
    if (_ref != null) {
      final pending = consumePendingSyncs();
      for (final entry in pending.entries) {
        final recipientDeviceId = entry.key;
        final payloadJson = entry.value;
        try {
          final encryptedPayload = await CryptoService.encrypt(
            payloadJson,
            recipientDeviceId,
          );
          final apiClient = ApiClient(baseUrl: _serverUrl!);
          await apiClient.sendMessage(
            senderDeviceId: _deviceId!,
            recipientDeviceId: recipientDeviceId,
            payload: encryptedPayload,
            messageType: 'FullSync',
          );
        } catch (_) {}
      }
    }
  }

  Future<void> _updatePendingConnection(String senderDeviceId) async {
    if (_ref == null) return;
    try {
      final db = _ref!.read(databaseProvider);
      final connections = await db.select(db.connections).get();
      for (final conn in connections) {
        if (conn.remoteDeviceId.startsWith('pending_')) {
          await _storage.write(
            key: 'refugium_partner_device_id',
            value: senderDeviceId,
          );
          _partnerDeviceId = senderDeviceId;
          await (db.update(
            db.connections,
          )..where((t) => t.id.equals(conn.id))).write(
            ConnectionsCompanion(remoteDeviceId: drift.Value(senderDeviceId)),
          );
          break;
        }
      }
    } catch (_) {}
  }

  Future<void> _startLocalServer() async {
    final router = Router();

    router.post('/sync', (Request request) async {
      try {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final senderDeviceId = data['sender_device_id'] as String?;
        final messageType = data['message_type'] as String?;
        final payload = data['payload'] as String?;

        if (senderDeviceId == null || senderDeviceId != _partnerDeviceId) {
          return Response.forbidden('Unknown device');
        }

        if (messageType != null && payload != null) {
          await _handleIncomingEvent(messageType, payload, senderDeviceId);
        }

        return Response.ok('ok');
      } catch (e) {
        return Response.internalServerError(body: e.toString());
      }
    });

    router.get('/ping', (Request request) async {
      return Response.ok(
        jsonEncode({'device_id': _deviceId}),
        headers: {'Content-Type': 'application/json'},
      );
    });

    final handler = Pipeline().addHandler(router.call);

    try {
      _localServer = await shelf_io.serve(
        handler,
        InternetAddress.anyIPv4,
        _localPort,
      );
    } catch (_) {}
  }

  Future<void> _startMdnsDiscovery() async {
    if (_deviceId == null) return;
    await NsdClient.registerService(_deviceId!);
    if (_partnerDeviceId != null) {
      _pollForPeers();
    }
  }

  Future<void> _pollForPeers() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      final services = await NsdClient.discoverServices();
      for (final service in services) {
        final host = service['host'] as String?;
        final port = service['port'] as int?;
        if (host == null || port == null) continue;
        final address = '$host:$port';
        try {
          final response = await http
              .get(Uri.parse('http://$address/ping'))
              .timeout(const Duration(seconds: 2));
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final deviceId = data['device_id'] as String?;
            if (deviceId == _partnerDeviceId) {
              _localPeers[deviceId!] = address;
            }
          }
        } catch (_) {}
      }
    }
  }

  Future<void> _handleIncomingEvent(
    String messageType,
    String payload,
    String? senderDeviceId,
  ) async {
    String decryptedPayload = payload;
    if (messageType != 'DeviceIntroduction' &&
        messageType != 'PublicKeyExchange' &&
        senderDeviceId != null) {
      try {
        decryptedPayload = await CryptoService.decrypt(payload, senderDeviceId);
      } catch (_) {
        decryptedPayload = payload;
      }
    }

    final data = jsonDecode(decryptedPayload) as Map<String, dynamic>;

    switch (messageType) {
      case 'DeviceIntroduction':
        final remoteDeviceId = data['device_id'] as String?;
        final remotePublicKey = data['public_key'] as String?;

        if (remoteDeviceId != null) {
          await _storage.write(
            key: 'refugium_partner_device_id',
            value: remoteDeviceId,
          );
          _partnerDeviceId = remoteDeviceId;
          await _updatePendingConnection(remoteDeviceId);
        }

        if (remoteDeviceId != null && remotePublicKey != null) {
          try {
            await CryptoService.deriveAndStoreSharedSecret(
              remoteDeviceId,
              remotePublicKey,
            );
          } catch (_) {}

          if (_serverUrl != null && _deviceId != null) {
            try {
              final ownPublicKey = await CryptoService.getPublicKeyBase64();
              final client = ApiClient(baseUrl: _serverUrl!);
              await client.sendMessage(
                senderDeviceId: _deviceId!,
                recipientDeviceId: remoteDeviceId,
                payload: '{"public_key":"$ownPublicKey"}',
                messageType: 'PublicKeyExchange',
              );
            } catch (_) {}
          }

          // Nach Schlüsseltausch FullSync senden
          if (_ref != null) {
            await sendFullSync(_ref!);
          }
        }
        break;

      case 'PublicKeyExchange':
        final remotePublicKey = data['public_key'] as String?;
        if (remotePublicKey != null && senderDeviceId != null) {
          try {
            await CryptoService.deriveAndStoreSharedSecret(
              senderDeviceId,
              remotePublicKey,
            );
          } catch (_) {}

          // Nach Schlüsseltausch FullSync senden
          if (_ref != null) {
            await sendFullSync(_ref!);
          }
        }
        break;

      case 'SwitchEvent':
        final partId = data['part_id'] as String? ?? 'remote';
        final partName = data['part_name'] as String? ?? 'Unbekannt';
        final note = data['note'] as String?;

        if (_ref != null) {
          try {
            final db = _ref!.read(databaseProvider);
            await db
                .into(db.switchEvents)
                .insert(
                  SwitchEventsCompanion.insert(
                    partId: partId,
                    markedBy: const drift.Value('PartnerObservation'),
                    note: drift.Value(note),
                    remotePartName: drift.Value(partName),
                  ),
                );
          } catch (_) {}
        }

        await NotificationService.showSwitchNotification(
          partName: partName,
          note: note,
        );
        break;

      case 'FullSync':
        // Remote-Daten in der DB speichern
        if (_ref != null && senderDeviceId != null) {
          try {
            final db = _ref!.read(databaseProvider);
            final connections = await db.select(db.connections).get();
            final conn = connections
                .where((c) => c.remoteDeviceId == senderDeviceId)
                .firstOrNull;
            if (conn != null) {
              await storeRemoteData(db, conn.id, data);
            }
            await NotificationService.showSyncNotification(
              'Daten wurden synchronisiert',
            );
          } catch (_) {}
        }
        break;

      case 'DisconnectEvent':
        if (_ref != null && senderDeviceId != null) {
          try {
            final db = _ref!.read(databaseProvider);
            await (db.delete(
              db.connections,
            )..where((t) => t.remoteDeviceId.equals(senderDeviceId))).go();
            await _storage.delete(key: 'refugium_partner_device_id');
            await CryptoService.deleteSharedSecret(senderDeviceId);
            _partnerDeviceId = null;
            await NotificationService.showSyncNotification(
              'Verbindung wurde vom anderen Gerät getrennt',
            );
          } catch (_) {}
        }
        break;

      case 'PartUpdate':
      case 'ConsentUpdate':
        // Bei inkrementellen Updates FullSync anfordern
        if (_ref != null && senderDeviceId != null) {
          await NotificationService.showSyncNotification(
            'Daten wurden aktualisiert',
          );
        }
        break;
    }
  }

  bool isPeerLocal(String deviceId) => _localPeers.containsKey(deviceId);
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});
