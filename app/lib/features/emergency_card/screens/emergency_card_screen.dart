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
import '../../../main.dart';

class EmergencyCardScreen extends ConsumerWidget {
  const EmergencyCardScreen({super.key});

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
                // Header
                _CardSection(
                  color: Colors.red.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'NOTFALLINFORMATION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Diese Person hat eine Dissoziative Identitätsstörung (ICD-10: F44.81)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Keine Psychose · Keine Drogen · Keine geistige Behinderung',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                // Medizinische Daten
                medicalAsync.maybeWhen(
                  data: (record) {
                    if (record == null) return const SizedBox.shrink();
                    final hasData =
                        record.bloodType != null ||
                        record.allergies != null ||
                        record.medications != null ||
                        record.healthInsuranceProvider != null;
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
                                if (record.bloodType != null)
                                  _MedRow('Blutgruppe', record.bloodType!),
                                if (record.allergies != null)
                                  _MedRow('Allergien', record.allergies!),
                                if (record.medications != null)
                                  _MedRow('Medikation', record.medications!),
                                if (record.healthInsuranceProvider != null)
                                  _MedRow(
                                    'Krankenkasse',
                                    '${record.healthInsuranceProvider!}'
                                        '${record.healthInsuranceMemberId != null ? " · ${record.healthInsuranceMemberId}" : ""}',
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),

                const SizedBox(height: 16),

                // Anteile
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

                // Ersthelfer-Hinweise
                Text(
                  'Hinweise für Ersthelfer',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                const _CardSection(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HintRow(
                        icon: Icons.check_circle_outline,
                        text: 'Ruhig und klar sprechen',
                      ),
                      _HintRow(
                        icon: Icons.check_circle_outline,
                        text:
                            'Nach dem Namen fragen: "Wie darf ich Sie ansprechen?"',
                      ),
                      _HintRow(
                        icon: Icons.check_circle_outline,
                        text: 'Überraschende Berührungen vermeiden',
                      ),
                      _HintRow(
                        icon: Icons.check_circle_outline,
                        text:
                            'Verwirrung oder Gedächtnislücken sind Teil der Störung',
                      ),
                      _HintRow(
                        icon: Icons.cancel_outlined,
                        text:
                            'Nicht auf Konsistenz bestehen oder konfrontieren',
                        isWarning: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Notfallkontakte
                Text(
                  'Notfallkontakte',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                contactsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text('Fehler: $e'),
                  data: (contacts) {
                    if (contacts.isEmpty) {
                      return const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Keine Notfallkontakte hinterlegt.'),
                        ),
                      );
                    }
                    return Column(
                      children: contacts.asMap().entries.map((entry) {
                        final i = entry.key;
                        final c = entry.value;
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
                                        '${i + 1}',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            c.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            c.relationship,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      c.phone,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 6,
                                  children: [
                                    _KnowledgeChip(
                                      'Diagnose',
                                      c.knowsAboutDiagnosis,
                                    ),
                                    _KnowledgeChip(
                                      'Anteile',
                                      c.knowsAboutParts,
                                    ),
                                    _KnowledgeChip(
                                      'Trauma',
                                      c.knowsAboutTrauma,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
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

    final Map<String, List<TriggerEntryData>> triggerMap = {};
    for (final part in emergencyParts) {
      final db = ref.read(databaseProvider);
      final triggers =
          await (db.select(db.triggerEntries)
                ..where(
                  (t) =>
                      t.partId.equals(part.id) &
                      t.appliesExternally.equals(true),
                )
                ..orderBy([(t) => OrderingTerm.desc(t.severity)]))
              .get();
      triggerMap[part.id] = triggers;
    }

    final contacts =
        await (ref
                .read(databaseProvider)
                .select(ref.read(databaseProvider).emergencyContacts)
              ..orderBy([(t) => OrderingTerm.asc(t.rank)]))
            .get();

    final medical = await ref
        .read(databaseProvider)
        .select(ref.read(databaseProvider).medicalRecords)
        .getSingleOrNull();

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.red),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'NOTFALLINFORMATION',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16,
                        color: PdfColors.red,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Dissoziative Identitätsstörung (ICD-10: F44.81)',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Keine Psychose · Keine Drogen · Keine geistige Behinderung',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),

              // Medizinische Daten
              if (medical != null) ...[
                pw.Text(
                  'Medizinische Daten',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (medical.bloodType != null)
                  pw.Text('Blutgruppe: ${medical.bloodType}'),
                if (medical.allergies != null)
                  pw.Text('Allergien: ${medical.allergies}'),
                if (medical.medications != null)
                  pw.Text('Medikation: ${medical.medications}'),
                if (medical.healthInsuranceProvider != null)
                  pw.Text(
                    'Krankenkasse: ${medical.healthInsuranceProvider}'
                    '${medical.healthInsuranceMemberId != null ? " · ${medical.healthInsuranceMemberId}" : ""}',
                  ),
                pw.SizedBox(height: 12),
              ],

              // Anteile
              pw.Text(
                'Bekannte Anteile',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 8),
              if (emergencyParts.isEmpty)
                pw.Text('Keine Anteile für Notfallkarte freigegeben.')
              else
                ...emergencyParts.map(
                  (part) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          part.displayName ?? 'Unbenannt',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        if (part.pronouns != null) pw.Text(part.pronouns!),
                        if (part.descriptionExternal != null)
                          pw.Text(part.descriptionExternal!),
                        if (triggerMap[part.id]?.isNotEmpty == true) ...[
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Trigger:',
                            style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                          ),
                          ...triggerMap[part.id]!.map(
                            (t) => pw.Text(
                              '· ${t.description}'
                              '${t.copingSuggestion != null ? " → ${t.copingSuggestion}" : ""}',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              pw.SizedBox(height: 12),

              // Ersthelfer
              pw.Text(
                'Hinweise für Ersthelfer',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text('· Ruhig und klar sprechen'),
              pw.Text(
                '· Nach dem Namen fragen: "Wie darf ich Sie ansprechen?"',
              ),
              pw.Text('· Überraschende Berührungen vermeiden'),
              pw.Text(
                '· Verwirrung oder Gedächtnislücken sind Teil der Störung',
              ),
              pw.Text('· Nicht auf Konsistenz bestehen oder konfrontieren'),

              // Notfallkontakte
              if (contacts.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                pw.Text(
                  'Notfallkontakte',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                pw.SizedBox(height: 4),
                ...contacts.asMap().entries.map(
                  (entry) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${entry.key + 1}. ${entry.value.name} (${entry.value.relationship}) – ${entry.value.phone}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Kennt: '
                          '${entry.value.knowsAboutDiagnosis ? "Diagnose " : ""}'
                          '${entry.value.knowsAboutParts ? "Anteile " : ""}'
                          '${entry.value.knowsAboutTrauma ? "Trauma" : ""}'
                          '${!entry.value.knowsAboutDiagnosis && !entry.value.knowsAboutParts && !entry.value.knowsAboutTrauma ? "nichts" : ""}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }
}

class _PartTileWithTriggers extends ConsumerWidget {
  final PartsData part;

  const _PartTileWithTriggers({required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final triggersAsync = ref.watch(triggerEntriesProvider(part.id));
    final externalTriggers = triggersAsync.maybeWhen(
      data: (triggers) => triggers.where((t) => t.appliesExternally).toList(),
      orElse: () => <TriggerEntryData>[],
    );

    final desc = part.descriptionExternal;
    final truncated = desc != null && desc.length > 80
        ? '${desc.substring(0, 80)}…'
        : desc;

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
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (part.pronouns != null) ...[
              const SizedBox(height: 2),
              Text(
                part.pronouns!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (truncated != null) ...[
              const Divider(height: 16),
              Text(truncated, style: Theme.of(context).textTheme.bodyMedium),
            ],
            if (externalTriggers.isNotEmpty) ...[
              const Divider(height: 16),
              Text(
                'Trigger',
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.red.shade700),
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
                        color: _severityColor(t.severity),
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

  Color _severityColor(String severity) {
    return switch (severity) {
      'Mild' => Colors.green.shade600,
      'Moderate' => Colors.orange.shade600,
      'Severe' => Colors.red.shade600,
      'Critical' => Colors.red.shade900,
      _ => Colors.grey,
    };
  }
}

class _KnowledgeChip extends StatelessWidget {
  final String label;
  final bool knows;

  const _KnowledgeChip(this.label, this.knows);

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        knows ? Icons.check_circle : Icons.cancel,
        size: 14,
        color: knows ? Colors.green.shade700 : Colors.red.shade700,
      ),
      label: Text(label, style: const TextStyle(fontSize: 10)),
      backgroundColor: knows ? Colors.green.shade50 : Colors.red.shade50,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _MedRow extends StatelessWidget {
  final String label;
  final String value;

  const _MedRow(this.label, this.value);

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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final Widget child;
  final Color? color;

  const _CardSection({required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 18, color: isWarning ? Colors.orange : Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
