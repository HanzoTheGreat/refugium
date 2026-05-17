import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database.dart';
import '../database/database_provider.dart';
import '../crypto/crypto_service.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

final connectionsProvider = StreamProvider<List<ConnectionData>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.connections,
  )..orderBy([(t) => OrderingTerm.desc(t.pairedAt)])).watch();
});

final activeConnectionProvider = StreamProvider<ConnectionData?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.connections)
        ..where((t) => t.isActive.equals(true))
        ..limit(1))
      .watchSingleOrNull();
});

Future<void> setActiveConnection(WidgetRef ref, String connectionId) async {
  final db = ref.read(databaseProvider);
  await (db.update(
    db.connections,
  )).write(const ConnectionsCompanion(isActive: Value(false)));
  await (db.update(db.connections)..where((t) => t.id.equals(connectionId)))
      .write(const ConnectionsCompanion(isActive: Value(true)));
}

Future<void> addConnection(
  WidgetRef ref, {
  required String remoteDeviceId,
  required String remoteDisplayName,
  required String role,
  bool makeActive = true,
}) async {
  final db = ref.read(databaseProvider);
  if (makeActive) {
    await (db.update(
      db.connections,
    )).write(const ConnectionsCompanion(isActive: Value(false)));
  }
  await db
      .into(db.connections)
      .insert(
        ConnectionsCompanion.insert(
          remoteDeviceId: remoteDeviceId,
          remoteDisplayName: remoteDisplayName,
          role: Value(role),
          isActive: Value(makeActive),
        ),
      );
}

Future<void> deleteConnection(WidgetRef ref, String connectionId) async {
  final db = ref.read(databaseProvider);
  final connections = await db.select(db.connections).get();
  final conn = connections.where((c) => c.id == connectionId).firstOrNull;

  if (conn != null && !conn.remoteDeviceId.startsWith('pending_')) {
    // Shared Secret löschen
    await CryptoService.deleteSharedSecret(conn.remoteDeviceId);

    // Storage-Key löschen damit _migrateOldPairing die Verbindung
    // beim nächsten App-Start nicht wiederherstellt
    final storedPartnerId = await _storage.read(
      key: 'refugium_partner_device_id',
    );
    if (storedPartnerId == conn.remoteDeviceId) {
      await _storage.delete(key: 'refugium_partner_device_id');
    }
  }

  await (db.delete(
    db.connections,
  )..where((t) => t.id.equals(connectionId))).go();
}

Future<void> disconnectAndNotify(
  WidgetRef ref,
  ConnectionData connection,
  String ownDeviceId,
  String serverUrl,
) async {
  await deleteConnection(ref, connection.id);

  if (!connection.remoteDeviceId.startsWith('pending_')) {
    try {
      final client = HttpClient();
      final uri = Uri.parse('$serverUrl/api/v1/messages/send');
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      request.write(
        '{"sender_device_id":"$ownDeviceId",'
        '"recipient_device_id":"${connection.remoteDeviceId}",'
        '"payload":"{}",'
        '"message_type":"DisconnectEvent"}',
      );
      await request.close();
      client.close();
    } catch (_) {}
  }
}
