import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../main.dart';

final triggerEntriesProvider =
    StreamProvider.family<List<TriggerEntryData>, String>((ref, partId) {
      final db = ref.watch(databaseProvider);
      return (db.select(db.triggerEntries)
            ..where((t) => t.partId.equals(partId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();
    });

Future<void> addTrigger(
  WidgetRef ref, {
  required String partId,
  required String description,
  String type = 'Other',
  String severity = 'Moderate',
  String? copingSuggestion,
  bool appliesExternally = false,
}) async {
  final db = ref.read(databaseProvider);
  await db
      .into(db.triggerEntries)
      .insert(
        TriggerEntriesCompanion.insert(
          partId: partId,
          description: description,
          type: Value(type),
          severity: Value(severity),
          copingSuggestion: Value(copingSuggestion),
          appliesExternally: Value(appliesExternally),
        ),
      );
}

Future<void> deleteTrigger(WidgetRef ref, String id) async {
  final db = ref.read(databaseProvider);
  await (db.delete(db.triggerEntries)..where((t) => t.id.equals(id))).go();
}
