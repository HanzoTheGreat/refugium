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
import 'foreground_service_channel.dart';
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
  AppDatabase? _db;
  bool _started = false;

  final Map<String, String> _localPeers = {};

  Future<void> start(WidgetRef ref, String serverUrl) async {
    if (_started) return;
    _started = true;

    _serverUrl = serverUrl;
    _db = ref.read(databaseProvider);
    _deviceId = await _storage.read(key: 'refugium_device_id');
    _partnerDeviceId = await _storage.read(key: 'refugium_partner_device_id');

    if (_deviceId == null) return;

    // ForegroundService starten (Android only) und triggerSync-Callback registrieren.
    // triggerSync → sofortiger Poll-Zyklus, kein Warten auf nächsten 15s-Timer.
    ForegroundServiceChannel.init(onTriggerSync: _pollServer);
    await ForegroundServiceChannel.startService(_deviceId!);

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
    await ForegroundServiceChannel.stopService();
  }

  // Ausstehende SwitchEvents die beim ersten Sendeversuch fehlgeschlagen sind.
  // Format: Liste von {recipientDeviceId, messageType, plainJson}
  final List<Map<String, String>> _pendingEvents = [];

  Future<void> sendSyncEvent({
    required String recipientDeviceId,
    required String messageType,
    required Map<String, dynamic> payload,
  }) async {
    final plainJson = jsonEncode(payload);

    // LAN zuerst versuchen
    if (_localPeers.containsKey(recipientDeviceId)) {
      final address = _localPeers[recipientDeviceId]!;
      try {
        final encryptedPayload = await CryptoService.encrypt(
          plainJson,
          recipientDeviceId,
        );
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

    // Server-Versuch
    if (_serverUrl != null && _deviceId != null) {
      try {
        final encryptedPayload = await CryptoService.encrypt(
          plainJson,
          recipientDeviceId,
        );
        final client = ApiClient(baseUrl: _serverUrl!);
        await client.sendMessage(
          senderDeviceId: _deviceId!,
          recipientDeviceId: recipientDeviceId,
          payload: encryptedPayload,
          messageType: messageType,
        );
        return; // Erfolgreich – nicht queuen
      } catch (e) {
        print('[SyncService] sendMessage error, queuing for retry: $e');
      }
    }

    // Fehlgeschlagen – in Retry-Queue
    _pendingEvents.add({
      'recipient': recipientDeviceId,
      'messageType': messageType,
      'plainJson': plainJson,
    });
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
    } catch (e) {
      print('[SyncService] pollServer error: $e');
    }

    // Ausstehende Events aus vorherigen fehlgeschlagenen Sendeversuchen
    if (_pendingEvents.isNotEmpty && _serverUrl != null && _deviceId != null) {
      final toRetry = List<Map<String, String>>.from(_pendingEvents);
      _pendingEvents.clear();
      for (final event in toRetry) {
        try {
          final encryptedPayload = await CryptoService.encrypt(
            event['plainJson']!,
            event['recipient']!,
          );
          final client = ApiClient(baseUrl: _serverUrl!);
          await client.sendMessage(
            senderDeviceId: _deviceId!,
            recipientDeviceId: event['recipient']!,
            payload: encryptedPayload,
            messageType: event['messageType']!,
          );
        } catch (e) {
          _pendingEvents.add(event);
          print('[SyncService] retry failed, requeued: $e');
        }
      }
    }

    if (_db != null) {
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
        } catch (e) {
          // Senden fehlgeschlagen – zurück in die Queue für nächsten Poll
          requeuePendingSync(recipientDeviceId, payloadJson);
          print('[SyncService] FullSync send error, requeued: $e');
        }
      }
    }
  }

  Future<void> _updatePendingConnection(String senderDeviceId) async {
    if (_db == null) return;
    try {
      final db = _db!;
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
    } catch (e) {
      print('[SyncService] _updatePendingConnection error: $e');
    }
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
    } catch (e) {
      print('[SyncService] local server error: $e');
    }
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
      } catch (e) {
        print('[SyncService] decrypt error: $e – trying plaintext');
        decryptedPayload = payload;
      }
    }

    final Map<String, dynamic> data;
    try {
      data = jsonDecode(decryptedPayload) as Map<String, dynamic>;
    } catch (e) {
      print('[SyncService] JSON parse error: $e');
      return;
    }

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
          } catch (e) {
            print('[SyncService] deriveSharedSecret error: $e');
          }

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
            } catch (e) {
              print('[SyncService] PublicKeyExchange send error: $e');
            }
          }

          if (_db != null) {
            await sendFullSyncFromDb(_db!);
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
          } catch (e) {
            print('[SyncService] deriveSharedSecret error: $e');
          }
          if (_db != null) {
            await sendFullSyncFromDb(_db!);
          }
        }
        break;

      case 'SwitchEvent':
        final partId = data['part_id'] as String? ?? 'remote';
        final partName = data['part_name'] as String? ?? 'Unbekannt';
        final note = data['note'] as String?;
        // Originalen Timestamp aus dem Payload nutzen, nicht DateTime.now().
        // Sonst kriegen alle Events die gebündelt ankommen denselben Timestamp.
        final tsRaw = data['timestamp'] as String?;
        final eventTimestamp = tsRaw != null
            ? DateTime.tryParse(tsRaw) ?? DateTime.now()
            : DateTime.now();

        if (_db != null) {
          try {
            final db = _db!;
            await db
                .into(db.switchEvents)
                .insert(
                  SwitchEventsCompanion.insert(
                    partId: partId,
                    timestamp: drift.Value(eventTimestamp),
                    markedBy: const drift.Value('PartnerObservation'),
                    note: drift.Value(note),
                    remotePartName: drift.Value(partName),
                  ),
                );
          } catch (e) {
            print('[SyncService] SwitchEvent insert error: $e');
          }
        }

        await NotificationService.showSwitchNotification(
          partName: partName,
          note: note,
        );
        break;

      case 'FullSync':
        if (_db != null && senderDeviceId != null) {
          try {
            final db = _db!;
            final connections = await db.select(db.connections).get();
            final conn = connections
                .where((c) => c.remoteDeviceId == senderDeviceId)
                .firstOrNull;
            if (conn != null) {
              await storeRemoteData(db, conn.id, data);
            } else {
              print(
                '[SyncService] FullSync: no connection found for $senderDeviceId',
              );
            }

            final rawEvents = data['switch_events'];
            if (rawEvents is List) {
              for (final e in rawEvents) {
                if (e is! Map<String, dynamic>) continue;
                final remoteId = e['id'] as String?;
                final partId = e['part_id'] as String?;
                final partName = e['part_name'] as String?;
                final tsRaw = e['timestamp'] as String?;
                final note = e['note'] as String?;
                if (remoteId == null || partId == null || tsRaw == null)
                  continue;
                final timestamp = DateTime.tryParse(tsRaw);
                if (timestamp == null) continue;

                try {
                  final existing = await (db.select(
                    db.switchEvents,
                  )..where((t) => t.id.equals(remoteId))).getSingleOrNull();
                  if (existing != null) continue;

                  await db
                      .into(db.switchEvents)
                      .insert(
                        SwitchEventsCompanion(
                          id: drift.Value(remoteId),
                          partId: drift.Value(partId),
                          timestamp: drift.Value(timestamp),
                          markedBy: const drift.Value('PartnerObservation'),
                          note: drift.Value(note),
                          remotePartName: drift.Value(partName),
                        ),
                      );
                } catch (e) {
                  print('[SyncService] switch_event insert error: $e');
                }
              }
            }
          } catch (e) {
            print('[SyncService] FullSync store error: $e');
          }
        }
        break;

      case 'SyncRequest':
        if (_db != null) {
          await sendFullSyncFromDb(_db!);
          print('[SyncService] SyncRequest empfangen – FullSync queued');
        }
        break;

      case 'DisconnectEvent':
        if (_db != null && senderDeviceId != null) {
          try {
            final db = _db!;
            await (db.delete(
              db.connections,
            )..where((t) => t.remoteDeviceId.equals(senderDeviceId))).go();
            await _storage.delete(key: 'refugium_partner_device_id');
            await CryptoService.deleteSharedSecret(senderDeviceId);
            _partnerDeviceId = null;
            await NotificationService.showSyncNotification(
              'Verbindung wurde vom anderen Gerät getrennt',
            );
          } catch (e) {
            print('[SyncService] DisconnectEvent error: $e');
          }
        }
        break;

      case 'PartUpdate':
      case 'ConsentUpdate':
        await NotificationService.showSyncNotification(
          'Daten wurden aktualisiert',
        );
        break;
    }
  }

  bool isPeerLocal(String deviceId) => _localPeers.containsKey(deviceId);
}

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});
