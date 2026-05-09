import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../parts_provider.dart';

class EditPartScreen extends ConsumerStatefulWidget {
  final PartsData part;

  const EditPartScreen({super.key, required this.part});

  @override
  ConsumerState<EditPartScreen> createState() => _EditPartScreenState();
}

class _EditPartScreenState extends ConsumerState<EditPartScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _pronounsController;
  late final TextEditingController _roleController;
  late final TextEditingController _apparentAgeController;
  late final TextEditingController _descInternalController;
  late final TextEditingController _descExternalController;
  late String _visibility;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.part.displayName ?? '',
    );
    _pronounsController = TextEditingController(
      text: widget.part.pronouns ?? '',
    );
    _roleController = TextEditingController(text: widget.part.role ?? '');
    _apparentAgeController = TextEditingController(
      text: widget.part.apparentAge ?? '',
    );
    _descInternalController = TextEditingController(
      text: widget.part.descriptionInternal ?? '',
    );
    _descExternalController = TextEditingController(
      text: widget.part.descriptionExternal ?? '',
    );
    _visibility = widget.part.visibility;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pronounsController.dispose();
    _roleController.dispose();
    _apparentAgeController.dispose();
    _descInternalController.dispose();
    _descExternalController.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String value) =>
      value.trim().isEmpty ? null : value.trim();

  Future<void> _save() async {
    setState(() => _saving = true);
    final updated = widget.part.copyWith(
      displayName: Value(_nullIfEmpty(_nameController.text)),
      pronouns: Value(_nullIfEmpty(_pronounsController.text)),
      role: Value(_nullIfEmpty(_roleController.text)),
      apparentAge: Value(_nullIfEmpty(_apparentAgeController.text)),
      descriptionInternal: Value(_nullIfEmpty(_descInternalController.text)),
      descriptionExternal: Value(_nullIfEmpty(_descExternalController.text)),
      visibility: _visibility,
      updatedAt: DateTime.now(),
    );
    await ref.read(partsProvider.notifier).updatePart(updated);
    if (mounted) Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anteil bearbeiten'),
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
          _buildField('Name', _nameController),
          _buildField('Pronomen', _pronounsController),
          _buildField('Rolle', _roleController),
          _buildField('Ungefähres Alter', _apparentAgeController),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _visibility,
            decoration: const InputDecoration(
              labelText: 'Sichtbarkeit',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'Emergency', child: Text('Notfall')),
              DropdownMenuItem(value: 'Partner', child: Text('Partner')),
              DropdownMenuItem(value: 'Therapist', child: Text('Therapeut:in')),
              DropdownMenuItem(value: 'Internal', child: Text('Intern')),
            ],
            onChanged: (v) => setState(() => _visibility = v ?? _visibility),
          ),
          const SizedBox(height: 16),
          _buildField(
            'Beschreibung (intern)',
            _descInternalController,
            maxLines: 4,
          ),
          _buildField(
            'Beschreibung (extern / Notfall)',
            _descExternalController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
