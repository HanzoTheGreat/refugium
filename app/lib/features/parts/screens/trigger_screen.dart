import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../trigger_provider.dart';
import '../widgets/edit_trigger_dialog.dart';

class TriggerScreen extends ConsumerWidget {
  final String partId;
  final String partName;

  const TriggerScreen({
    super.key,
    required this.partId,
    required this.partName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final triggersAsync = ref.watch(triggerEntriesProvider(partId));

    return Scaffold(
      appBar: AppBar(title: Text('Trigger – $partName')),
      body: triggersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (triggers) {
          if (triggers.isEmpty) {
            return const Center(child: Text('Noch keine Trigger eingetragen.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: triggers.length,
            itemBuilder: (context, index) {
              final trigger = triggers[index];
              return _TriggerCard(
                trigger: trigger,
                onDelete: () => deleteTrigger(ref, trigger.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => _AddTriggerDialog(partId: partId),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TriggerCard extends StatelessWidget {
  final TriggerEntryData trigger;
  final VoidCallback onDelete;

  const _TriggerCard({required this.trigger, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (trigger.severity) {
      'Mild' => (Colors.green.shade50, 'Mild'),
      'Moderate' => (Colors.orange.shade50, 'Moderat'),
      'Severe' => (Colors.red.shade50, 'Schwer'),
      'Critical' => (Colors.red.shade100, 'Kritisch'),
      _ => (Colors.grey.shade50, trigger.severity),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    trigger.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(label, style: const TextStyle(fontSize: 11)),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => EditTriggerDialog(trigger: trigger),
                  ),
                  color: Colors.grey,
                ),
              ],
            ),
            if (trigger.copingSuggestion != null) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 16,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      trigger.copingSuggestion!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            if (trigger.appliesExternally) ...[
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.emergency, size: 14, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    'Auf Notfallkarte sichtbar',
                    style: TextStyle(fontSize: 11, color: Colors.red),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AddTriggerDialog extends ConsumerStatefulWidget {
  final String partId;

  const _AddTriggerDialog({required this.partId});

  @override
  ConsumerState<_AddTriggerDialog> createState() => _AddTriggerDialogState();
}

class _AddTriggerDialogState extends ConsumerState<_AddTriggerDialog> {
  final _descController = TextEditingController();
  final _copingController = TextEditingController();
  String _type = 'Other';
  String _severity = 'Moderate';
  bool _appliesExternally = false;
  bool _saving = false;

  @override
  void dispose() {
    _descController.dispose();
    _copingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_descController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await addTrigger(
      ref,
      partId: widget.partId,
      description: _descController.text.trim(),
      type: _type,
      severity: _severity,
      copingSuggestion: _copingController.text.trim().isEmpty
          ? null
          : _copingController.text.trim(),
      appliesExternally: _appliesExternally,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Trigger hinzufügen'),
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
              initialValue: _type,
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
              initialValue: _severity,
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
