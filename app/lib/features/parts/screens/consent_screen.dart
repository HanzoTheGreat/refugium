import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../consent_provider.dart';

class ConsentScreen extends ConsumerStatefulWidget {
  final String partId;
  final String partName;

  const ConsentScreen({
    super.key,
    required this.partId,
    required this.partName,
  });

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  String _touchGeneral = 'Unknown';
  String _touchIntimate = 'Unknown';
  String _kiss = 'Unknown';
  String _petNames = 'Unknown';
  String _sexualActivity = 'Unknown';
  String _driving = 'Unknown';
  String _alcohol = 'Unknown';
  String _decisionsFinancial = 'Unknown';
  String _decisionsMedical = 'Unknown';

  final _notesController = TextEditingController();
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final profile = await ref.read(
      consentProfileProvider(widget.partId).future,
    );
    if (profile != null) {
      final p = profile;
      setState(() {
        _touchGeneral = p.touchGeneral;
        _touchIntimate = p.touchIntimate;
        _kiss = p.kiss;
        _petNames = p.petNames;
        _sexualActivity = p.sexualActivity;
        _driving = p.driving;
        _alcohol = p.alcohol;
        _decisionsFinancial = p.decisionsFinancial;
        _decisionsMedical = p.decisionsMedical;
        _notesController.text = p.notes ?? '';
      });
    }
    setState(() => _loaded = true);
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await upsertConsent(
      ref,
      ConsentProfilesCompanion(
        partId: Value(widget.partId),
        touchGeneral: Value(_touchGeneral),
        touchIntimate: Value(_touchIntimate),
        kiss: Value(_kiss),
        petNames: Value(_petNames),
        sexualActivity: Value(_sexualActivity),
        driving: Value(_driving),
        alcohol: Value(_alcohol),
        decisionsFinancial: Value(_decisionsFinancial),
        decisionsMedical: Value(_decisionsMedical),
        notes: Value(
          _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
        lastReviewed: Value(DateTime.now()),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Consent – ${widget.partName}'),
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
          _SectionHeader('Körperlich & Intimität'),
          _ConsentRow(
            label: 'Allgemeine Berührung',
            value: _touchGeneral,
            onChanged: (v) => setState(() => _touchGeneral = v),
          ),
          _ConsentRow(
            label: 'Intime Berührung',
            value: _touchIntimate,
            onChanged: (v) => setState(() => _touchIntimate = v),
          ),
          _ConsentRow(
            label: 'Küssen',
            value: _kiss,
            onChanged: (v) => setState(() => _kiss = v),
          ),
          _ConsentRow(
            label: 'Kosenamen',
            value: _petNames,
            onChanged: (v) => setState(() => _petNames = v),
          ),
          _ConsentRow(
            label: 'Sexuelle Aktivität',
            value: _sexualActivity,
            onChanged: (v) => setState(() => _sexualActivity = v),
          ),
          const SizedBox(height: 16),
          _SectionHeader('Verantwortung & Aktivitäten'),
          _ConsentRow(
            label: 'Autofahren',
            value: _driving,
            onChanged: (v) => setState(() => _driving = v),
          ),
          _ConsentRow(
            label: 'Alkohol',
            value: _alcohol,
            onChanged: (v) => setState(() => _alcohol = v),
          ),
          _ConsentRow(
            label: 'Finanzielle Entscheidungen',
            value: _decisionsFinancial,
            onChanged: (v) => setState(() => _decisionsFinancial = v),
          ),
          _ConsentRow(
            label: 'Medizinische Entscheidungen',
            value: _decisionsMedical,
            onChanged: (v) => setState(() => _decisionsMedical = v),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Notizen',
              border: OutlineInputBorder(),
            ),
          ),
        ],
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

class _ConsentRow extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const _ConsentRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<String>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: 'Yes', label: Text('Ja')),
                ButtonSegment(value: 'AskFirst', label: Text('Fragen')),
                ButtonSegment(value: 'No', label: Text('Nein')),
                ButtonSegment(value: 'Unknown', label: Text('?')),
              ],
              selected: {value},
              onSelectionChanged: (s) => onChanged(s.first),
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
            ),
          ),
        ],
      ),
    );
  }
}
