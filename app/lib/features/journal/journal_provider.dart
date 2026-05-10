import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

final journalEntriesProvider = StreamProvider<List<JournalEntryData>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.journalEntries,
  )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();
});

final journalByPartProvider =
    StreamProvider.family<List<JournalEntryData>, String>((ref, partId) {
      final db = ref.watch(databaseProvider);
      return (db.select(db.journalEntries)
            ..where((t) => t.partId.equals(partId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();
    });

Future<void> addJournalEntry(
  WidgetRef ref, {
  String? partId,
  required String content,
  String? mood,
  bool isPrivate = false,
}) async {
  final db = ref.read(databaseProvider);
  await db
      .into(db.journalEntries)
      .insert(
        JournalEntriesCompanion.insert(
          partId: Value(partId),
          content: content,
          mood: Value(mood),
          isPrivate: Value(isPrivate),
        ),
      );
}

Future<void> updateJournalEntry(
  WidgetRef ref, {
  required String id,
  required String content,
  String? mood,
  bool? isPrivate,
}) async {
  final db = ref.read(databaseProvider);
  await (db.update(db.journalEntries)..where((t) => t.id.equals(id))).write(
    JournalEntriesCompanion(
      content: Value(content),
      mood: Value(mood),
      isPrivate: isPrivate != null ? Value(isPrivate) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ),
  );
}

Future<void> deleteJournalEntry(WidgetRef ref, String id) async {
  final db = ref.read(databaseProvider);
  await (db.delete(db.journalEntries)..where((t) => t.id.equals(id))).go();
}
