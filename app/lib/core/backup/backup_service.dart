import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../database/database.dart';
import '../database/database_provider.dart';
import 'package:drift/drift.dart';

class BackupService {
  static Future<void> exportBackup(BuildContext context, WidgetRef ref) async {
    try {
      final db = ref.read(databaseProvider);

      // Alle Daten laden
      final parts = await db.select(db.parts).get();
      final switchEvents = await db.select(db.switchEvents).get();
      final consentProfiles = await db.select(db.consentProfiles).get();
      final triggerEntries = await db.select(db.triggerEntries).get();
      final emergencyContacts = await db.select(db.emergencyContacts).get();
      final medicalRecords = await db.select(db.medicalRecords).get();
      final journalEntries = await db.select(db.journalEntries).get();

      final backup = {
        'version': 1,
        'exported_at': DateTime.now().toIso8601String(),
        'parts': parts
            .map(
              (p) => {
                'id': p.id,
                'display_name': p.displayName,
                'pronouns': p.pronouns,
                'apparent_age': p.apparentAge,
                'role': p.role,
                'description_internal': p.descriptionInternal,
                'description_external': p.descriptionExternal,
                'visibility': p.visibility,
                'status': p.status,
                'integrated_into': p.integratedInto,
                'emerged_at': p.emergedAt?.toIso8601String(),
                'emergence_context': p.emergenceContext,
                'created_at': p.createdAt.toIso8601String(),
                'updated_at': p.updatedAt.toIso8601String(),
              },
            )
            .toList(),
        'switch_events': switchEvents
            .map(
              (e) => {
                'id': e.id,
                'part_id': e.partId,
                'timestamp': e.timestamp.toIso8601String(),
                'marked_by': e.markedBy,
                'context_tags': e.contextTags,
                'note': e.note,
              },
            )
            .toList(),
        'consent_profiles': consentProfiles
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
                'last_reviewed': c.lastReviewed.toIso8601String(),
              },
            )
            .toList(),
        'trigger_entries': triggerEntries
            .map(
              (t) => {
                'id': t.id,
                'part_id': t.partId,
                'type': t.type,
                'description': t.description,
                'severity': t.severity,
                'coping_suggestion': t.copingSuggestion,
                'applies_externally': t.appliesExternally,
                'created_at': t.createdAt.toIso8601String(),
              },
            )
            .toList(),
        'emergency_contacts': emergencyContacts
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
                'notes': c.notes,
                'created_at': c.createdAt.toIso8601String(),
              },
            )
            .toList(),
        'medical_records': medicalRecords
            .map(
              (m) => {
                'id': m.id,
                'blood_type': m.bloodType,
                'allergies': m.allergies,
                'medications': m.medications,
                'diagnoses': m.diagnoses,
                'primary_physician': m.primaryPhysician,
                'health_insurance_provider': m.healthInsuranceProvider,
                'health_insurance_member_id': m.healthInsuranceMemberId,
                'notes': m.notes,
                'updated_at': m.updatedAt.toIso8601String(),
              },
            )
            .toList(),
        'journal_entries': journalEntries
            .map(
              (j) => {
                'id': j.id,
                'part_id': j.partId,
                'content': j.content,
                'mood': j.mood,
                'is_private': j.isPrivate,
                'created_at': j.createdAt.toIso8601String(),
                'updated_at': j.updatedAt.toIso8601String(),
              },
            )
            .toList(),
      };

      final json = const JsonEncoder.withIndent('  ').convert(backup);
      final bytes = utf8.encode(json);

      // In temporäre Datei schreiben
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .substring(0, 19);
      final file = File('${dir.path}/refugium_backup_$timestamp.json');
      await file.writeAsBytes(bytes);

      // Teilen
      await Share.shareXFiles([
        XFile(file.path),
      ], subject: 'Refugium Backup $timestamp');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Export fehlgeschlagen: $e')));
      }
    }
  }

  static Future<void> importBackup(
    BuildContext context,
    WidgetRef ref,
    String jsonContent,
  ) async {
    try {
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;
      final version = data['version'] as int? ?? 1;

      if (version != 1) {
        throw Exception('Unbekannte Backup-Version: $version');
      }

      final db = ref.read(databaseProvider);

      // Bestätigung einholen
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Backup importieren'),
          content: const Text(
            'Alle vorhandenen Daten werden überschrieben. '
            'Dieser Vorgang kann nicht rückgängig gemacht werden.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Importieren'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      // Daten löschen
      await db.delete(db.journalEntries).go();
      await db.delete(db.triggerEntries).go();
      await db.delete(db.consentProfiles).go();
      await db.delete(db.switchEvents).go();
      await db.delete(db.emergencyContacts).go();
      await db.delete(db.medicalRecords).go();
      await db.delete(db.parts).go();

      // Parts importieren
      final parts = data['parts'] as List? ?? [];
      for (final p in parts) {
        await db
            .into(db.parts)
            .insert(
              PartsCompanion.insert(
                id: Value(p['id'] as String),
                displayName: Value(p['display_name'] as String?),
                pronouns: Value(p['pronouns'] as String?),
                apparentAge: Value(p['apparent_age'] as String?),
                role: Value(p['role'] as String?),
                descriptionInternal: Value(
                  p['description_internal'] as String?,
                ),
                descriptionExternal: Value(
                  p['description_external'] as String?,
                ),
                visibility: Value(p['visibility'] as String? ?? 'Internal'),
                status: Value(p['status'] as String? ?? 'Active'),
                integratedInto: Value(p['integrated_into'] as String?),
                emergedAt: Value(
                  p['emerged_at'] != null
                      ? DateTime.parse(p['emerged_at'] as String)
                      : null,
                ),
                emergenceContext: Value(p['emergence_context'] as String?),
              ),
            );
      }

      // Consent-Profile importieren
      final consents = data['consent_profiles'] as List? ?? [];
      for (final c in consents) {
        await db
            .into(db.consentProfiles)
            .insert(
              ConsentProfilesCompanion.insert(
                partId: c['part_id'] as String,
                touchGeneral: Value(c['touch_general'] as String? ?? 'Unknown'),
                touchIntimate: Value(
                  c['touch_intimate'] as String? ?? 'Unknown',
                ),
                kiss: Value(c['kiss'] as String? ?? 'Unknown'),
                petNames: Value(c['pet_names'] as String? ?? 'Unknown'),
                sexualActivity: Value(
                  c['sexual_activity'] as String? ?? 'Unknown',
                ),
                driving: Value(c['driving'] as String? ?? 'Unknown'),
                alcohol: Value(c['alcohol'] as String? ?? 'Unknown'),
                decisionsFinancial: Value(
                  c['decisions_financial'] as String? ?? 'Unknown',
                ),
                decisionsMedical: Value(
                  c['decisions_medical'] as String? ?? 'Unknown',
                ),
                notes: Value(c['notes'] as String?),
              ),
            );
      }

      // Trigger importieren
      final triggers = data['trigger_entries'] as List? ?? [];
      for (final t in triggers) {
        await db
            .into(db.triggerEntries)
            .insert(
              TriggerEntriesCompanion.insert(
                id: Value(t['id'] as String),
                partId: t['part_id'] as String,
                description: t['description'] as String,
                type: Value(t['type'] as String? ?? 'Other'),
                severity: Value(t['severity'] as String? ?? 'Moderate'),
                copingSuggestion: Value(t['coping_suggestion'] as String?),
                appliesExternally: Value(
                  t['applies_externally'] as bool? ?? false,
                ),
              ),
            );
      }

      // Notfallkontakte importieren
      final contacts = data['emergency_contacts'] as List? ?? [];
      for (final c in contacts) {
        await db
            .into(db.emergencyContacts)
            .insert(
              EmergencyContactsCompanion.insert(
                id: Value(c['id'] as String),
                rank: Value(c['rank'] as int? ?? 0),
                name: c['name'] as String,
                relationship: c['relationship'] as String,
                phone: c['phone'] as String,
                email: Value(c['email'] as String?),
                knowsAboutDiagnosis: Value(
                  c['knows_about_diagnosis'] as bool? ?? false,
                ),
                knowsAboutParts: Value(
                  c['knows_about_parts'] as bool? ?? false,
                ),
                knowsAboutTrauma: Value(
                  c['knows_about_trauma'] as bool? ?? false,
                ),
                preferredContactMethod: Value(
                  c['preferred_contact_method'] as String? ?? 'Phone',
                ),
                availableHours: Value(c['available_hours'] as String?),
                notes: Value(c['notes'] as String?),
              ),
            );
      }

      // Medizinische Daten importieren
      final medicals = data['medical_records'] as List? ?? [];
      for (final m in medicals) {
        await db
            .into(db.medicalRecords)
            .insert(
              MedicalRecordsCompanion.insert(
                id: Value(m['id'] as String),
                bloodType: Value(m['blood_type'] as String?),
                allergies: Value(m['allergies'] as String?),
                medications: Value(m['medications'] as String?),
                diagnoses: Value(m['diagnoses'] as String?),
                primaryPhysician: Value(m['primary_physician'] as String?),
                healthInsuranceProvider: Value(
                  m['health_insurance_provider'] as String?,
                ),
                healthInsuranceMemberId: Value(
                  m['health_insurance_member_id'] as String?,
                ),
                notes: Value(m['notes'] as String?),
              ),
            );
      }

      // Journal importieren
      final journals = data['journal_entries'] as List? ?? [];
      for (final j in journals) {
        await db
            .into(db.journalEntries)
            .insert(
              JournalEntriesCompanion.insert(
                id: Value(j['id'] as String),
                partId: Value(j['part_id'] as String?),
                content: j['content'] as String,
                mood: Value(j['mood'] as String?),
                isPrivate: Value(j['is_private'] as bool? ?? false),
              ),
            );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup erfolgreich importiert')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Import fehlgeschlagen: $e')));
      }
    }
  }
}
