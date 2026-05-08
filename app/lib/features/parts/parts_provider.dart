import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../main.dart';

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
  }

  Future<void> updatePart(PartsData part) async {
    final db = ref.read(databaseProvider);
    await db.update(db.parts).replace(part);
  }

  Future<void> setPartStatus(String id, String status) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.parts)..where((t) => t.id.equals(id))).write(
      PartsCompanion(status: Value(status)),
    );
  }
}
