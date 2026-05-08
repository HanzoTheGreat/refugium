import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../parts_provider.dart';

class AddPartDialog extends ConsumerStatefulWidget {
  const AddPartDialog({super.key});

  @override
  ConsumerState<AddPartDialog> createState() => _AddPartDialogState();
}

class _AddPartDialogState extends ConsumerState<AddPartDialog> {
  final _nameController = TextEditingController();
  final _pronounsController = TextEditingController();
  final _roleController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _pronounsController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    await ref
        .read(partsProvider.notifier)
        .addPart(
          displayName: _nameController.text.trim(),
          pronouns: _pronounsController.text.trim().isEmpty
              ? null
              : _pronounsController.text.trim(),
          role: _roleController.text.trim().isEmpty
              ? null
              : _roleController.text.trim(),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Anteil anlegen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pronounsController,
            decoration: const InputDecoration(labelText: 'Pronomen (optional)'),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _roleController,
            decoration: const InputDecoration(labelText: 'Rolle (optional)'),
          ),
        ],
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
