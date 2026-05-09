import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../medical_record_provider.dart';
import '../../../main.dart';

class MedicalRecordScreen extends ConsumerStatefulWidget {
  const MedicalRecordScreen({super.key});

  @override
  ConsumerState<MedicalRecordScreen> createState() =>
      _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends ConsumerState<MedicalRecordScreen> {
  final _bloodTypeController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _diagnosesController = TextEditingController();
  final _physicianController = TextEditingController();
  final _insuranceProviderController = TextEditingController();
  final _insuranceMemberIdController = TextEditingController();
  final _notesController = TextEditingController();

  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = ref.read(databaseProvider);
    final record = await db.select(db.medicalRecords).getSingleOrNull();
    if (record != null) {
      setState(() {
        _bloodTypeController.text = record.bloodType ?? '';
        _allergiesController.text = record.allergies ?? '';
        _medicationsController.text = record.medications ?? '';
        _diagnosesController.text = record.diagnoses ?? '';
        _physicianController.text = record.primaryPhysician ?? '';
        _insuranceProviderController.text =
            record.healthInsuranceProvider ?? '';
        _insuranceMemberIdController.text =
            record.healthInsuranceMemberId ?? '';
        _notesController.text = record.notes ?? '';
      });
    }
    setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _diagnosesController.dispose();
    _physicianController.dispose();
    _insuranceProviderController.dispose();
    _insuranceMemberIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String v) => v.trim().isEmpty ? null : v.trim();

  Future<void> _save() async {
    setState(() => _saving = true);
    await saveMedicalRecord(
      ref,
      MedicalRecordsCompanion(
        bloodType: Value(_nullIfEmpty(_bloodTypeController.text)),
        allergies: Value(_nullIfEmpty(_allergiesController.text)),
        medications: Value(_nullIfEmpty(_medicationsController.text)),
        diagnoses: Value(_nullIfEmpty(_diagnosesController.text)),
        primaryPhysician: Value(_nullIfEmpty(_physicianController.text)),
        healthInsuranceProvider: Value(
          _nullIfEmpty(_insuranceProviderController.text),
        ),
        healthInsuranceMemberId: Value(
          _nullIfEmpty(_insuranceMemberIdController.text),
        ),
        notes: Value(_nullIfEmpty(_notesController.text)),
        updatedAt: Value(DateTime.now()),
      ),
    );
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gespeichert')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medizinische Daten'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Speichern'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader('Allgemein'),
          _field('Blutgruppe', _bloodTypeController, hint: 'z.B. A+, 0-, AB+'),
          const SizedBox(height: 16),
          _SectionHeader('Allergien'),
          _field(
            'Allergien',
            _allergiesController,
            hint: 'z.B. Penicillin, Latex, Nüsse',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _SectionHeader('Medikation'),
          _field(
            'Aktuelle Medikamente',
            _medicationsController,
            hint: 'Name, Dosis, Häufigkeit – eine pro Zeile',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          _SectionHeader('Diagnosen'),
          _field(
            'Diagnosen',
            _diagnosesController,
            hint: 'z.B. F44.81 Dissoziative Identitätsstörung – eine pro Zeile',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _SectionHeader('Behandelnde Person'),
          _field(
            'Hausarzt / Psychiater',
            _physicianController,
            hint: 'Name, Telefon',
          ),
          const SizedBox(height: 16),
          _SectionHeader('Krankenversicherung'),
          _field(
            'Krankenkasse',
            _insuranceProviderController,
            hint: 'z.B. AOK, TK, Barmer',
          ),
          _field('Versichertennummer', _insuranceMemberIdController),
          const SizedBox(height: 16),
          _SectionHeader('Weitere Hinweise'),
          _field(
            'Notizen',
            _notesController,
            hint:
                'z.B. abgelehnte Medikamente, besondere Hinweise für Notaufnahme',
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleSmall),
    );
  }
}
