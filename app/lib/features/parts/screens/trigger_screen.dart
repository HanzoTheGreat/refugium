import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/sync/app_mode_provider.dart';
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
    final mode = ref.watch(activeModeProvider);
    final canEdit = mode == AppMode.patient;

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
                canEdit: canEdit,
                onDelete: () => deleteTrigger(ref, trigger.id),
              );
            },
          );
        },
      ),
      floatingActionButton: canEdit
          ? FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => _AddTriggerDialog(partId: partId),
              ),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _TriggerCard extends StatelessWidget {
  final TriggerEntryData trigger;
  final VoidCallback onDelete;
  final bool canEdit;

  const _TriggerCard({
    required this.trigger,
    required this.onDelete,
    required this.canEdit,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // Helle semantische Hintergründe – Text immer Colors.black87 für Kontrast
    final (bgColor, severityLabel) = switch (trigger.severity) {
      'Mild' => (Colors.green.shade50, 'Mild'),
      'Moderate' => (Colors.orange.shade50, 'Moderat'),
      'Severe' => (Colors.red.shade50, 'Schwer'),
      'Critical' => (Colors.red.shade100, 'Kritisch'),
      _ => (Colors.grey.shade50, trigger.severity),
    };

    // Explizite dunkle Textfarbe für alle Inhalte auf farbigem Hintergrund
    const onCard = Colors.black87;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: bgColor,
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: onCard,
                      fontSize: 14,
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: Colors.white.withOpacity(0.45),
                  label: Text(
                    severityLabel,
                    style: const TextStyle(fontSize: 11, color: onCard),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                if (canEdit) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    color: Colors.black54,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => EditTriggerDialog(trigger: trigger),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    color: Colors.black54,
                    onPressed: onDelete,
                  ),
                ],
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
                      style: const TextStyle(fontSize: 13, color: onCard),
                    ),
                  ),
                ],
              ),
            ],
            if (trigger.appliesExternally) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.emergency, size: 14, color: cs.error),
                  const SizedBox(width: 4),
                  Text(
                    'Auf Notfallkarte sichtbar',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.error,
                      fontWeight: FontWeight.w600,
                    ),
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
