import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../main.dart';

class EditTriggerDialog extends ConsumerStatefulWidget {
  final TriggerEntryData trigger;

  const EditTriggerDialog({super.key, required this.trigger});

  @override
  ConsumerState<EditTriggerDialog> createState() => _EditTriggerDialogState();
}

class _EditTriggerDialogState extends ConsumerState<EditTriggerDialog> {
  late final TextEditingController _descController;
  late final TextEditingController _copingController;
  late String _type;
  late String _severity;
  late bool _appliesExternally;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _descController = TextEditingController(text: widget.trigger.description);
    _copingController = TextEditingController(
      text: widget.trigger.copingSuggestion ?? '',
    );
    _type = widget.trigger.type;
    _severity = widget.trigger.severity;
    _appliesExternally = widget.trigger.appliesExternally;
  }

  @override
  void dispose() {
    _descController.dispose();
    _copingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_descController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    await (db.update(
      db.triggerEntries,
    )..where((t) => t.id.equals(widget.trigger.id))).write(
      TriggerEntriesCompanion(
        description: Value(_descController.text.trim()),
        type: Value(_type),
        severity: Value(_severity),
        copingSuggestion: Value(
          _copingController.text.trim().isEmpty
              ? null
              : _copingController.text.trim(),
        ),
        appliesExternally: Value(_appliesExternally),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trigger bearbeiten'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descController,
              decoration: const InputDecoration(labelText: 'Beschreibung'),
              autofocus: true,
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'Typ'),
              items: const [
                DropdownMenuItem(value: 'Sensory', child: Text('Sensorisch')),
                DropdownMenuItem(value: 'Social', child: Text('Sozial')),
                DropdownMenuItem(value: 'Situational', child: Text('Situativ')),
                DropdownMenuItem(
                  value: 'DateBased',
                  child: Text('Datumsbasiert'),
                ),
                DropdownMenuItem(value: 'Other', child: Text('Sonstiges')),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _severity,
              decoration: const InputDecoration(labelText: 'Schweregrad'),
              items: const [
                DropdownMenuItem(value: 'Mild', child: Text('Mild')),
                DropdownMenuItem(value: 'Moderate', child: Text('Moderat')),
                DropdownMenuItem(value: 'Severe', child: Text('Schwer')),
                DropdownMenuItem(value: 'Critical', child: Text('Kritisch')),
              ],
              onChanged: (v) => setState(() => _severity = v ?? _severity),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _copingController,
              decoration: const InputDecoration(
                labelText: 'Coping-Vorschlag (optional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _appliesExternally,
              onChanged: (v) => setState(() => _appliesExternally = v),
              title: const Text('Auf Notfallkarte sichtbar'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
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
    );
  }
}
