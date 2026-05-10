import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../database/database_provider.dart';

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
  await (db.delete(
    db.connections,
  )..where((t) => t.id.equals(connectionId))).go();
}
