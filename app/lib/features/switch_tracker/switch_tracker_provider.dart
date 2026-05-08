import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../main.dart';

// Aktueller Anteil – wird nur im Speicher gehalten (letzte SwitchEvent in DB)
final currentPartProvider = FutureProvider<SwitchEventsData?>((ref) async {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.switchEvents)
    ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
    ..limit(1);
  final results = await query.get();
  return results.isEmpty ? null : results.first;
});

final switchHistoryProvider = FutureProvider<List<SwitchEventsData>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.switchEvents)
    ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
    ..limit(20);
  return query.get();
});

class SwitchTrackerNotifier extends AsyncNotifier<SwitchEventsData?> {
  @override
  Future<SwitchEventsData?> build() async {
    final db = ref.watch(databaseProvider);
    final query = db.select(db.switchEvents)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
      ..limit(1);
    final results = await query.get();
    return results.isEmpty ? null : results.first;
  }

  Future<void> switchTo(String partId, {String? note}) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.switchEvents)
        .insert(
          SwitchEventsCompanion.insert(
            partId: partId,
            markedBy: const Value('SelfCheckin'),
            note: Value(note),
          ),
        );
    ref.invalidateSelf();
    ref.invalidate(currentPartProvider);
    ref.invalidate(switchHistoryProvider);
  }
}

final switchTrackerProvider =
    AsyncNotifierProvider<SwitchTrackerNotifier, SwitchEventsData?>(
      SwitchTrackerNotifier.new,
    );
