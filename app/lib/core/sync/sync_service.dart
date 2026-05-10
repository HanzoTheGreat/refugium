import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import 'sync_provider.dart';
import 'nsd_client.dart';
import 'notification_service.dart';
import '../database/database_provider.dart';

const _localPort = 7890;
const _serviceType = '_refugium._tcp';
const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Singleton SyncService – wird einmal gestartet und läuft im Hintergrund
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  HttpServer? _localServer;
  String? _deviceId;
  String? _partnerDeviceId;
  String? _serverUrl;
  WidgetRef? _ref;

  // Bekannte lokale Peer-Adressen: deviceId -> IP:Port
  final Map<String, String> _localPeers = {};

  Future<void> start(WidgetRef ref, String serverUrl) async {
    _ref = ref;
    _serverUrl = serverUrl;
    _deviceId = await _storage.read(key: 'refugium_device_id');
    _partnerDeviceId = await _storage.read(key: 'refugium_partner_device_id');

    if (_deviceId == null) return;

    await _startLocalServer();
    await _startMdnsDiscovery();
  }

  Future<void> stop() async {
    await _localServer?.close(force: true);
    _localServer = null;
  }

  /// Nachricht senden – lokal wenn möglich, sonst via Server
  Future<void> sendSyncEvent({
    required String recipientDeviceId,
    required String messageType,
    required Map<String, dynamic> payload,
  }) async {
    final payloadJson = jsonEncode(payload);

    // Lokal versuchen
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
                'payload': payloadJson,
              }),
            )
            .timeout(const Duration(seconds: 3));
        if (response.statusCode == 200) {
          return; // Lokal erfolgreich
        }
      } catch (_) {
        // Lokal fehlgeschlagen – Peer aus Liste entfernen, via Server senden
        _localPeers.remove(recipientDeviceId);
      }
    }

    // Server-Fallback
    if (_serverUrl != null && _deviceId != null) {
      try {
        final client = ApiClient(baseUrl: _serverUrl!);
        await client.sendMessage(
          senderDeviceId: _deviceId!,
          recipientDeviceId: recipientDeviceId,
          payload: payloadJson,
          messageType: messageType,
        );
      } catch (e) {
        // Server auch nicht erreichbar – still fail, kein Crash
      }
    }
  }

  /// Lokalen HTTP-Server starten – empfängt eingehende Sync-Events
  Future<void> _startLocalServer() async {
    final router = Router();

    router.post('/sync', (Request request) async {
      try {
        final body = await request.readAsString();
        final data = jsonDecode(body) as Map<String, dynamic>;
        final senderDeviceId = data['sender_device_id'] as String?;
        final messageType = data['message_type'] as String?;
        final payload = data['payload'] as String?;

        // Nur von bekanntem Partner akzeptieren
        if (senderDeviceId == null || senderDeviceId != _partnerDeviceId) {
          return Response.forbidden('Unknown device');
        }

        if (messageType != null && payload != null) {
          await _handleIncomingEvent(messageType, payload);
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
    } catch (_) {
      // Port bereits belegt – kein Problem, wir nutzen Server-Fallback
    }
  }

  /// mDNS Discovery starten
  Future<void> _startMdnsDiscovery() async {
    if (_deviceId == null) return;

    // Eigenes Gerät registrieren
    await NsdClient.registerService(_deviceId!);

    // Partner suchen via Polling alle 30 Sekunden
    if (_partnerDeviceId != null) {
      _pollForPeers();
    }
  }

  Future<void> _pollForPeers() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      final services = await NsdClient.discoverServices();
      for (final service in services) {
        final name = service['name'] as String?;
        final host = service['host'] as String?;
        final port = service['port'] as int?;
        if (name != null && host != null && port != null) {
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
  }

  /// Eingehende Sync-Events verarbeiten
  Future<void> _handleIncomingEvent(String messageType, String payload) async {
    final data = jsonDecode(payload) as Map<String, dynamic>;

    switch (messageType) {
      case 'SwitchEvent':
        final partId = data['part_id'] as String?;
        final note = data['note'] as String?;

        // Anteilname aus DB laden wenn möglich
        String partName = 'Unbekannt';
        if (_ref != null && partId != null) {
          try {
            final db = _ref!.read(databaseProvider);
            final parts = await db.select(db.parts).get();
            final part = parts.where((p) => p.id == partId).firstOrNull;
            if (part != null) {
              partName = part.displayName ?? 'Unbekannt';
            }
          } catch (_) {}
        }

        await NotificationService.showSwitchNotification(
          partName: partName,
          note: note,
        );
        break;

      case 'PartUpdate':
        await NotificationService.showSyncNotification(
          'Anteil wurde aktualisiert',
        );
        break;

      case 'ConsentUpdate':
        await NotificationService.showSyncNotification(
          'Consent wurde aktualisiert',
        );
        break;

      case 'FullSync':
        await NotificationService.showSyncNotification(
          'Vollständiger Sync erhalten',
        );
        break;
    }
  }

  bool isPeerLocal(String deviceId) => _localPeers.containsKey(deviceId);
}

/// Provider für den SyncService
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});
