import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/database.dart';
import '../database/database_provider.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

/// Baut das FullSync-Payload gefiltert nach Empfängerrolle
Map<String, dynamic> buildFullSyncPayload({
  required String recipientRole,
  required List<PartsData> parts,
  required List<ConsentProfileData> consentProfiles,
  required List<TriggerEntryData> triggers,
  required List<EmergencyContactData> contacts,
  required MedicalRecordData? medical,
  required List<JournalEntryData> journal,
}) {
  // Sichtbare Visibility-Level je Rolle
  final allowedVisibility = switch (recipientRole) {
    'partner' => ['Emergency', 'Partner'],
    'therapist' => ['Emergency', 'Partner', 'Therapist'],
    _ => ['Emergency'],
  };

  final visibleParts = parts
      .where(
        (p) => allowedVisibility.contains(p.visibility) && p.status == 'Active',
      )
      .toList();

  final visiblePartIds = visibleParts.map((p) => p.id).toSet();

  // Nur externe Trigger der sichtbaren Anteile
  final visibleTriggers = triggers
      .where((t) => visiblePartIds.contains(t.partId) && t.appliesExternally)
      .toList();

  // Consent-Profile der sichtbaren Anteile
  final visibleConsent = consentProfiles
      .where((c) => visiblePartIds.contains(c.partId))
      .toList();

  // Journal: nur nicht-private Einträge, nur für Therapeuten
  final visibleJournal = recipientRole == 'therapist'
      ? journal.where((j) => !j.isPrivate).toList()
      : <JournalEntryData>[];

  return {
    'version': 1,
    'role': recipientRole,
    'parts': visibleParts
        .map(
          (p) => {
            'id': p.id,
            'display_name': p.displayName,
            'pronouns': p.pronouns,
            'apparent_age': p.apparentAge,
            'role': p.role,
            // Niemals: descriptionInternal, emergenceContext
            'description_external': p.descriptionExternal,
            'visibility': p.visibility,
            'status': p.status,
          },
        )
        .toList(),
    'consent_profiles': visibleConsent
        .map(
          (c) => {
            'part_id': c.partId,
            'touch_general': c.touchGeneral,
            'touch_intimate': c.touchIntimate,
            'kiss': c.kiss,
            'pet_names': c.petNames,
            'sexual_activity': c.sexualActivity,
            'driving': c.driving,
            'alcohol': c.alcohol,
            'decisions_financial': c.decisionsFinancial,
            'decisions_medical': c.decisionsMedical,
            'notes': c.notes,
          },
        )
        .toList(),
    'triggers': visibleTriggers
        .map(
          (t) => {
            'id': t.id,
            'part_id': t.partId,
            'type': t.type,
            'description': t.description,
            'severity': t.severity,
            'coping_suggestion': t.copingSuggestion,
          },
        )
        .toList(),
    'emergency_contacts': contacts
        .map(
          (c) => {
            'id': c.id,
            'rank': c.rank,
            'name': c.name,
            'relationship': c.relationship,
            'phone': c.phone,
            'email': c.email,
            'knows_about_diagnosis': c.knowsAboutDiagnosis,
            'knows_about_parts': c.knowsAboutParts,
            'knows_about_trauma': c.knowsAboutTrauma,
            'preferred_contact_method': c.preferredContactMethod,
            'available_hours': c.availableHours,
          },
        )
        .toList(),
    'medical_record': medical == null
        ? null
        : {
            'blood_type': medical.bloodType,
            'allergies': medical.allergies,
            'medications': medical.medications,
            'diagnoses': medical.diagnoses,
            'primary_physician': medical.primaryPhysician,
            'health_insurance_provider': medical.healthInsuranceProvider,
            'health_insurance_member_id': medical.healthInsuranceMemberId,
          },
    'journal': visibleJournal
        .map(
          (j) => {
            'id': j.id,
            'part_id': j.partId,
            'content': j.content,
            'mood': j.mood,
            'created_at': j.createdAt.toIso8601String(),
          },
        )
        .toList(),
  };
}

/// Sendet FullSync an alle aktiven Verbindungen
Future<void> sendFullSync(WidgetRef ref) async {
  final db = ref.read(databaseProvider);
  final deviceId = await _storage.read(key: 'refugium_device_id');
  if (deviceId == null) return;

  final connections = await db.select(db.connections).get();
  final activeConnections = connections.where(
    (c) => !c.remoteDeviceId.startsWith('pending_'),
  );

  if (!activeConnections.iterator.moveNext()) return;

  // Alle Daten laden
  final parts = await db.select(db.parts).get();
  final consentProfiles = await db.select(db.consentProfiles).get();
  final triggers = await db.select(db.triggerEntries).get();
  final contacts = await (db.select(
    db.emergencyContacts,
  )..orderBy([(t) => OrderingTerm.asc(t.rank)])).get();
  final medical = await db.select(db.medicalRecords).getSingleOrNull();
  final journal = await db.select(db.journalEntries).get();

  for (final conn in connections) {
    if (conn.remoteDeviceId.startsWith('pending_')) continue;

    final payload = buildFullSyncPayload(
      recipientRole: conn.role,
      parts: parts,
      consentProfiles: consentProfiles,
      triggers: triggers,
      contacts: contacts,
      medical: medical,
      journal: journal,
    );

    // Payload über SyncService senden (wird dort verschlüsselt)
    // Wir speichern den Callback um zirkuläre Imports zu vermeiden
    _pendingSyncs[conn.remoteDeviceId] = jsonEncode(payload);
  }
}

// Temporärer Speicher für ausstehende FullSync-Payloads
final Map<String, String> _pendingSyncs = {};

/// Ausstehende FullSync-Payloads abrufen und leeren
Map<String, String> consumePendingSyncs() {
  final result = Map<String, String>.from(_pendingSyncs);
  _pendingSyncs.clear();
  return result;
}

/// Empfangene FullSync-Daten in der DB speichern
Future<void> storeRemoteData(
  AppDatabase db,
  String connectionId,
  Map<String, dynamic> data,
) async {
  final json = jsonEncode(data);
  await (db.update(db.connections)..where((t) => t.id.equals(connectionId)))
      .write(ConnectionsCompanion(remoteData: Value(json)));
}

/// Remote-Daten einer Verbindung laden
Future<Map<String, dynamic>?> loadRemoteData(
  AppDatabase db,
  String connectionId,
) async {
  final conn = await (db.select(
    db.connections,
  )..where((t) => t.id.equals(connectionId))).getSingleOrNull();
  if (conn?.remoteData == null) return null;
  return jsonDecode(conn!.remoteData!) as Map<String, dynamic>;
}
