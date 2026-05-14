import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/full_sync_service.dart';

final medicalRecordProvider = StreamProvider<MedicalRecordData?>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.medicalRecords).watchSingleOrNull();
});

Future<void> saveMedicalRecord(
  WidgetRef ref,
  MedicalRecordsCompanion companion,
) async {
  final db = ref.read(databaseProvider);
  final existing = await db.select(db.medicalRecords).getSingleOrNull();
  if (existing == null) {
    await db.into(db.medicalRecords).insert(companion);
  } else {
    await (db.update(
      db.medicalRecords,
    )..where((t) => t.id.equals(existing.id))).write(companion);
  }
  sendFullSync(ref);
}
