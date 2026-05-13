import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../core/sync/sync_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Lokaler aktueller Anteil – live via Stream
final currentPartProvider = StreamProvider<SwitchEventsData?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.switchEvents)
        ..where((t) => t.markedBy.equals('SelfCheckin'))
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
        ..limit(1))
      .watchSingleOrNull();
});

// Remote aktueller Anteil – live via Stream
final remoteCurrentPartProvider = StreamProvider<SwitchEventsData?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.switchEvents)
        ..where((t) => t.markedBy.equals('PartnerObservation'))
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
        ..limit(1))
      .watchSingleOrNull();
});

// Lokale History – live via Stream
final switchHistoryProvider = StreamProvider<List<SwitchEventsData>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.switchEvents)
        ..where((t) => t.markedBy.equals('SelfCheckin'))
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
        ..limit(20))
      .watch();
});

// Remote History – live via Stream
final remoteSwitchHistoryProvider = StreamProvider<List<SwitchEventsData>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.switchEvents)
        ..where((t) => t.markedBy.equals('PartnerObservation'))
        ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
        ..limit(20))
      .watch();
});

class SwitchTrackerNotifier extends AsyncNotifier<SwitchEventsData?> {
  @override
  Future<SwitchEventsData?> build() async {
    final db = ref.watch(databaseProvider);
    final query = db.select(db.switchEvents)
      ..where((t) => t.markedBy.equals('SelfCheckin'))
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

    // Anteilname mitschicken damit Partner ihn anzeigen kann
    final parts = await db.select(db.parts).get();
    final part = parts.where((p) => p.id == partId).firstOrNull;
    final partName = part?.displayName ?? 'Unbekannt';

    // Sync-Event senden
    final partnerDeviceId = await const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ).read(key: 'refugium_partner_device_id');

    if (partnerDeviceId != null) {
      ref
          .read(syncServiceProvider)
          .sendSyncEvent(
            recipientDeviceId: partnerDeviceId,
            messageType: 'SwitchEvent',
            payload: {
              'part_id': partId,
              'part_name': partName,
              'timestamp': DateTime.now().toIso8601String(),
              'note': note,
            },
          );
    }
  }
}

final switchTrackerProvider =
    AsyncNotifierProvider<SwitchTrackerNotifier, SwitchEventsData?>(
      SwitchTrackerNotifier.new,
    );
