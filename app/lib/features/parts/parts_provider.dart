import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/full_sync_service.dart';

final partsProvider = StreamNotifierProvider<PartsNotifier, List<PartsData>>(
  PartsNotifier.new,
);

class PartsNotifier extends StreamNotifier<List<PartsData>> {
  @override
  Stream<List<PartsData>> build() {
    final db = ref.watch(databaseProvider);
    return db.select(db.parts).watch();
  }

  Future<void> addPart({
    required String displayName,
    String? pronouns,
    String? apparentAge,
    String? role,
    String? descriptionInternal,
    String? descriptionExternal,
  }) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.parts)
        .insert(
          PartsCompanion.insert(
            displayName: Value(displayName),
            pronouns: Value(pronouns),
            apparentAge: Value(apparentAge),
            role: Value(role),
            descriptionInternal: Value(descriptionInternal),
            descriptionExternal: Value(descriptionExternal),
          ),
        );
    // sendFullSyncFromDb statt sendFullSync(ref as WidgetRef):
    // ref in StreamNotifier ist kein WidgetRef – der Cast wirft zur Laufzeit.
    await sendFullSyncFromDb(db);
  }

  Future<void> updatePart(PartsData part) async {
    final db = ref.read(databaseProvider);
    await db.update(db.parts).replace(part);
    await sendFullSyncFromDb(db);
  }

  Future<void> setPartStatus(String id, String status) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.parts)..where((t) => t.id.equals(id))).write(
      PartsCompanion(status: Value(status)),
    );
    await sendFullSyncFromDb(db);
  }

  Future<void> deletePart(String id) async {
    final db = ref.read(databaseProvider);
    await (db.delete(db.parts)..where((t) => t.id.equals(id))).go();
    await sendFullSyncFromDb(db);
  }
}
