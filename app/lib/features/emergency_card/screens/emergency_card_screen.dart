import 'dart:convert';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../parts/parts_provider.dart';
import '../../parts/trigger_provider.dart';
import '../emergency_contacts_provider.dart';
import '../medical_record_provider.dart';
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/sync/app_mode_provider.dart';
import '../../../core/sync/connection_provider.dart';

class EmergencyCardScreen extends ConsumerWidget {
  const EmergencyCardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(activeModeProvider);
    if (mode == AppMode.patient) {
      return const _LocalEmergencyCard();
    } else {
      return const _RemoteEmergencyCard();
    }
  }
}

// ── Lokale Notfallkarte (Patient-Modus) ─────────────────────────────────────

class _LocalEmergencyCard extends ConsumerWidget {
  const _LocalEmergencyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(partsProvider);
    final contactsAsync = ref.watch(emergencyContactsProvider);
    final medicalAsync = ref.watch(medicalRecordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notfallkarte'),
        actions: [
          partsAsync.maybeWhen(
            data: (parts) => IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Als PDF exportieren',
              onPressed: () => _exportPdf(context, ref, parts),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: partsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (parts) {
          final emergencyParts = parts
              .where((p) => p.visibility == 'Emergency' && p.status == 'Active')
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EmergencyHeader(),
                medicalAsync.maybeWhen(
                  data: (record) => _MedicalSection(record: record),
                  orElse: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Bekannte Anteile',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (emergencyParts.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Keine Anteile für Notfallkarte freigegeben.\n'
                        'Sichtbarkeit eines Anteils auf "Notfall" setzen.',
                      ),
                    ),
                  )
                else
                  ...emergencyParts.map(
                    (part) => _PartTileWithTriggers(part: part),
                  ),
                const SizedBox(height: 16),
                _FirstResponderHints(),
                const SizedBox(height: 16),
                Text(
                  'Notfallkontakte',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                contactsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Fehler: $e'),
                  data: (contacts) => contacts.isEmpty
                      ? const Card(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('Keine Notfallkontakte hinterlegt.'),
                          ),
                        )
                      : Column(
                          children: contacts.asMap().entries.map((e) {
                            return _ContactCard(
                              contact: e.value,
                              rank: e.key + 1,
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _exportPdf(
    BuildContext context,
    WidgetRef ref,
    List<PartsData> parts,
  ) async {
    final emergencyParts = parts
        .where((p) => p.visibility == 'Emergency' && p.status == 'Active')
        .toList();

    final db = ref.read(databaseProvider);
    final contacts = await (db.select(
      db.emergencyContacts,
    )..orderBy([(t) => OrderingTerm.asc(t.rank)])).get();
    final medical = await db.select(db.medicalRecords).getSingleOrNull();
    final allTriggers = await db.select(db.triggerEntries).get();

    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context ctx) => [
          // ── Notfall-Header ───────────────────────────────────────────────
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(14),
            decoration: pw.BoxDecoration(
              color: PdfColors.red50,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '⚠  NOTFALLINFORMATION',
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.red800,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'Diese Person hat eine Dissoziative Identitätsstörung (ICD-10: F44.81)',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  'Keine Psychose · Keine Drogen · Keine geistige Behinderung',
                  style: pw.TextStyle(
                    fontStyle: pw.FontStyle.italic,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // ── Medizinische Daten ────────────────────────────────────────────
          if (medical != null &&
              (medical.bloodType != null ||
                  medical.allergies != null ||
                  medical.medications != null)) ...[
            pw.SizedBox(height: 14),
            pw.Text(
              'Medizinische Daten',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.SizedBox(height: 5),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (medical.bloodType != null)
                    _pdfRow('Blutgruppe', medical.bloodType!),
                  if (medical.allergies != null)
                    _pdfRow('Allergien', medical.allergies!),
                  if (medical.medications != null)
                    _pdfRow('Medikation', medical.medications!),
                  if (medical.healthInsuranceProvider != null)
                    _pdfRow(
                      'Krankenkasse',
                      '${medical.healthInsuranceProvider!}'
                          '${medical.healthInsuranceMemberId != null ? " · ${medical.healthInsuranceMemberId}" : ""}',
                    ),
                ],
              ),
            ),
          ],

          // ── Bekannte Anteile ──────────────────────────────────────────────
          if (emergencyParts.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            pw.Text(
              'Bekannte Anteile',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.SizedBox(height: 5),
            ...emergencyParts.map((part) {
              final triggers = allTriggers
                  .where((t) => t.partId == part.id && t.appliesExternally)
                  .toList();
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 7),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      part.displayName ?? 'Unbenannt',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    if (part.pronouns != null)
                      pw.Text(
                        part.pronouns!,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    if (part.descriptionExternal != null) ...[
                      pw.SizedBox(height: 4),
                      pw.Text(
                        part.descriptionExternal!,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                    if (triggers.isNotEmpty) ...[
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Trigger:',
                        style: pw.TextStyle(
                          fontSize: 10,
                          color: PdfColors.red800,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      ...triggers.map(
                        (t) => pw.Text(
                          '• ${t.description}'
                          '${t.copingSuggestion != null ? "  →  ${t.copingSuggestion}" : ""}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],

          // ── Ersthelfer-Hinweise ───────────────────────────────────────────
          pw.SizedBox(height: 14),
          pw.Text(
            'Hinweise für Ersthelfer',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
          ),
          pw.SizedBox(height: 5),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '✓  Ruhig und klar sprechen',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '✓  Nach dem Namen fragen: "Wie darf ich Sie ansprechen?"',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '✓  Überraschende Berührungen vermeiden',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '✓  Verwirrung oder Gedächtnislücken sind Teil der Störung',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 3),
                pw.Text(
                  '✗  Nicht auf Konsistenz bestehen oder konfrontieren',
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.orange800),
                ),
              ],
            ),
          ),

          // ── Notfallkontakte ───────────────────────────────────────────────
          if (contacts.isNotEmpty) ...[
            pw.SizedBox(height: 14),
            pw.Text(
              'Notfallkontakte',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.SizedBox(height: 5),
            ...contacts.asMap().entries.map((entry) {
              final c = entry.value;
              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 6),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${entry.key + 1}.  ${c.name}',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      '${c.relationship} · ${c.phone}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    if (c.email != null)
                      pw.Text(
                        c.email!,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}

// ── Remote Notfallkarte (Partner/Therapeut-Modus) ───────────────────────────

class _RemoteEmergencyCard extends ConsumerWidget {
  const _RemoteEmergencyCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(activeModeProvider);
    final connectionsAsync = ref.watch(connectionsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Notfallkarte')),
      body: connectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (connections) {
          final expectedRole = mode == AppMode.therapist
              ? 'therapist'
              : 'partner';
          final connection = connections
              .where((c) => c.isActive && c.role == expectedRole)
              .firstOrNull;

          if (connection == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link_off, size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      mode == AppMode.therapist
                          ? 'Keine aktive Therapeut:in-Verbindung.'
                          : 'Keine aktive Partner-Verbindung.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'In den Einstellungen ein Gerät verbinden und aktivieren.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          }

          if (connection.remoteData == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.sync, size: 48, color: cs.onSurfaceVariant),
                    const SizedBox(height: 16),
                    Text(
                      'Noch keine Daten von ${connection.remoteDisplayName} empfangen.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Daten werden automatisch nach dem Pairing übertragen.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final data =
              jsonDecode(connection.remoteData!) as Map<String, dynamic>;
          return _RemoteEmergencyCardContent(
            data: data,
            connectionName: connection.remoteDisplayName,
          );
        },
      ),
    );
  }
}

class _RemoteEmergencyCardContent extends StatelessWidget {
  final Map<String, dynamic> data;
  final String connectionName;

  const _RemoteEmergencyCardContent({
    required this.data,
    required this.connectionName,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final parts = (data['parts'] as List? ?? []).cast<Map<String, dynamic>>();
    final consentProfiles = (data['consent_profiles'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final triggers = (data['triggers'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final contacts = (data['emergency_contacts'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final medical = data['medical_record'] as Map<String, dynamic>?;
    final journal = (data['journal'] as List? ?? [])
        .cast<Map<String, dynamic>>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sync-Quelle Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.sync, size: 16, color: cs.primary),
                const SizedBox(width: 8),
                Text(
                  'Daten von $connectionName',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onPrimaryContainer),
                ),
              ],
            ),
          ),

          _EmergencyHeader(),

          if (medical != null) ...[
            const SizedBox(height: 16),
            Text(
              'Medizinische Daten',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (medical['blood_type'] != null)
                      _MedRow(
                        label: 'Blutgruppe',
                        value: medical['blood_type'] as String,
                      ),
                    if (medical['allergies'] != null)
                      _MedRow(
                        label: 'Allergien',
                        value: medical['allergies'] as String,
                      ),
                    if (medical['medications'] != null)
                      _MedRow(
                        label: 'Medikation',
                        value: medical['medications'] as String,
                      ),
                    if (medical['health_insurance_provider'] != null)
                      _MedRow(
                        label: 'Krankenkasse',
                        value:
                            '${medical['health_insurance_provider']}'
                            '${medical['health_insurance_member_id'] != null ? " · ${medical['health_insurance_member_id']}" : ""}',
                      ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Text(
            'Bekannte Anteile',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (parts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Keine Anteile freigegeben.'),
              ),
            )
          else
            ...parts.map((part) {
              final partId = part['id'] as String;
              final partTriggers = triggers
                  .where((t) => t['part_id'] == partId)
                  .toList();
              final consent = consentProfiles
                  .where((c) => c['part_id'] == partId)
                  .firstOrNull;
              return _RemotePartTile(
                part: part,
                triggers: partTriggers,
                consent: consent,
              );
            }),

          const SizedBox(height: 16),
          _FirstResponderHints(),

          const SizedBox(height: 16),
          Text(
            'Notfallkontakte',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (contacts.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Keine Notfallkontakte.'),
              ),
            )
          else
            ...contacts.asMap().entries.map((e) {
              final c = e.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            child: Text(
                              '${e.key + 1}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c['name'] as String,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  c['relationship'] as String,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        c['phone'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            }),

          if (journal.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Journal (geteilt)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            ...journal.map(
              (j) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (j['mood'] != null)
                        Text(
                          j['mood'] as String,
                          style: const TextStyle(fontSize: 20),
                        ),
                      Text(
                        j['content'] as String,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        j['created_at'] as String? ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RemotePartTile extends StatelessWidget {
  final Map<String, dynamic> part;
  final List<Map<String, dynamic>> triggers;
  final Map<String, dynamic>? consent;

  const _RemotePartTile({
    required this.part,
    required this.triggers,
    this.consent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final desc = part['description_external'] as String?;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              part['display_name'] as String? ?? 'Unbenannt',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (part['pronouns'] != null) ...[
              const SizedBox(height: 2),
              Text(
                part['pronouns'] as String,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (desc != null) ...[
              const Divider(height: 16),
              Text(desc, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (triggers.isNotEmpty) ...[
              const Divider(height: 16),
              Text(
                'Trigger',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.error,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              ...triggers.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 14,
                        color: _severityColor(
                          context,
                          t['severity'] as String? ?? '',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (t['coping_suggestion'] != null)
                              Text(
                                '→ ${t['coping_suggestion']}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _severityColor(BuildContext context, String severity) {
    final cs = Theme.of(context).colorScheme;
    return switch (severity) {
      'Mild' => cs.primary,
      'Moderate' => Colors.orange.shade600,
      'Severe' => cs.error,
      'Critical' => cs.error,
      _ => cs.onSurfaceVariant,
    };
  }
}

// ── Geteilte Widgets ─────────────────────────────────────────────────────────

/// Roter Notfall-Header – nutzt errorContainer für korrekte Dark-Mode-Darstellung
class _EmergencyHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: cs.onErrorContainer),
              const SizedBox(width: 8),
              Text(
                'NOTFALLINFORMATION',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cs.onErrorContainer,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Diese Person hat eine Dissoziative Identitätsstörung (ICD-10: F44.81)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: cs.onErrorContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Keine Psychose · Keine Drogen · Keine geistige Behinderung',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: cs.onErrorContainer.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicalSection extends StatelessWidget {
  final MedicalRecordData? record;
  const _MedicalSection({required this.record});

  @override
  Widget build(BuildContext context) {
    if (record == null) return const SizedBox.shrink();
    final hasData =
        record!.bloodType != null ||
        record!.allergies != null ||
        record!.medications != null ||
        record!.healthInsuranceProvider != null;
    if (!hasData) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Medizinische Daten',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (record!.bloodType != null)
                  _MedRow(label: 'Blutgruppe', value: record!.bloodType!),
                if (record!.allergies != null)
                  _MedRow(label: 'Allergien', value: record!.allergies!),
                if (record!.medications != null)
                  _MedRow(label: 'Medikation', value: record!.medications!),
                if (record!.healthInsuranceProvider != null)
                  _MedRow(
                    label: 'Krankenkasse',
                    value:
                        '${record!.healthInsuranceProvider!}${record!.healthInsuranceMemberId != null ? " · ${record!.healthInsuranceMemberId}" : ""}',
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Ersthelfer-Hinweise – surfaceVariant als Hintergrund für korrekte Dark-Mode-Darstellung
class _FirstResponderHints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HintRow(
            icon: Icons.check_circle_outline,
            text: 'Ruhig und klar sprechen',
          ),
          _HintRow(
            icon: Icons.check_circle_outline,
            text: 'Nach dem Namen fragen: "Wie darf ich Sie ansprechen?"',
          ),
          _HintRow(
            icon: Icons.check_circle_outline,
            text: 'Überraschende Berührungen vermeiden',
          ),
          _HintRow(
            icon: Icons.check_circle_outline,
            text: 'Verwirrung oder Gedächtnislücken sind Teil der Störung',
          ),
          _HintRow(
            icon: Icons.cancel_outlined,
            text: 'Nicht auf Konsistenz bestehen oder konfrontieren',
            isWarning: true,
          ),
        ],
      ),
    );
  }
}

class _PartTileWithTriggers extends ConsumerWidget {
  final PartsData part;

  const _PartTileWithTriggers({required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final triggersAsync = ref.watch(triggerEntriesProvider(part.id));
    final externalTriggers = triggersAsync.maybeWhen(
      data: (triggers) => triggers.where((t) => t.appliesExternally).toList(),
      orElse: () => <TriggerEntryData>[],
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              part.displayName ?? 'Unbenannt',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (part.pronouns != null) ...[
              const SizedBox(height: 2),
              Text(
                part.pronouns!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (part.descriptionExternal != null) ...[
              const Divider(height: 16),
              Text(
                part.descriptionExternal!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            ...[
              const Divider(height: 16),
              Text(
                'Trigger',
                style: TextStyle(
                  fontSize: 11,
                  color: cs.error,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 4),
              ...externalTriggers.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.warning_amber_outlined,
                        size: 14,
                        color: _severityColor(context, t.severity),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.description,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (t.copingSuggestion != null)
                              Text(
                                '→ ${t.copingSuggestion}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(fontStyle: FontStyle.italic),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _severityColor(BuildContext context, String severity) {
    final cs = Theme.of(context).colorScheme;
    return switch (severity) {
      'Mild' => cs.primary,
      'Moderate' => Colors.orange.shade600,
      'Severe' => cs.error,
      'Critical' => cs.error,
      _ => cs.onSurfaceVariant,
    };
  }
}

class _ContactCard extends StatelessWidget {
  final EmergencyContactData contact;
  final int rank;

  const _ContactCard({required this.contact, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              child: Text('$rank', style: const TextStyle(fontSize: 11)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    contact.relationship,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    contact.phone,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 4,
              children: [
                if (contact.knowsAboutDiagnosis)
                  _KnowledgeChip('Diagnose', true),
                if (contact.knowsAboutParts) _KnowledgeChip('Anteile', true),
                if (contact.knowsAboutTrauma) _KnowledgeChip('Trauma', true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _KnowledgeChip extends StatelessWidget {
  final String label;
  final bool knows;

  const _KnowledgeChip(this.label, this.knows);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(
        knows ? Icons.check_circle : Icons.cancel,
        size: 14,
        color: knows ? cs.onPrimaryContainer : cs.onErrorContainer,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: knows ? cs.onPrimaryContainer : cs.onErrorContainer,
        ),
      ),
      backgroundColor: knows ? cs.primaryContainer : cs.errorContainer,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _MedRow extends StatelessWidget {
  final String label;
  final String value;

  const _MedRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isWarning;

  const _HintRow({
    required this.icon,
    required this.text,
    this.isWarning = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isWarning ? Colors.orange.shade600 : cs.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

// PDF-Hilfsfunktion – Label + Wert nebeneinander
pw.Widget _pdfRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 80,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    ),
  );
}
