import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/full_sync_service.dart';

final emergencyContactsProvider = StreamProvider<List<EmergencyContactData>>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return (db.select(
    db.emergencyContacts,
  )..orderBy([(t) => OrderingTerm.asc(t.rank)])).watch();
});

Future<void> addEmergencyContact(
  WidgetRef ref, {
  required String name,
  required String relationship,
  required String phone,
  String? email,
  int rank = 0,
  bool knowsAboutDiagnosis = false,
  bool knowsAboutParts = false,
  bool knowsAboutTrauma = false,
  String preferredContactMethod = 'Phone',
  String? availableHours,
  String? notes,
}) async {
  final db = ref.read(databaseProvider);
  await db
      .into(db.emergencyContacts)
      .insert(
        EmergencyContactsCompanion.insert(
          name: name,
          relationship: relationship,
          phone: phone,
          email: Value(email),
          rank: Value(rank),
          knowsAboutDiagnosis: Value(knowsAboutDiagnosis),
          knowsAboutParts: Value(knowsAboutParts),
          knowsAboutTrauma: Value(knowsAboutTrauma),
          preferredContactMethod: Value(preferredContactMethod),
          availableHours: Value(availableHours),
          notes: Value(notes),
        ),
      );
  sendFullSync(ref);
}

Future<void> updateEmergencyContact(
  WidgetRef ref,
  EmergencyContactData contact,
) async {
  final db = ref.read(databaseProvider);
  await db.update(db.emergencyContacts).replace(contact);
  sendFullSync(ref);
}

Future<void> deleteEmergencyContact(WidgetRef ref, String id) async {
  final db = ref.read(databaseProvider);
  await (db.delete(db.emergencyContacts)..where((t) => t.id.equals(id))).go();
  sendFullSync(ref);
}
