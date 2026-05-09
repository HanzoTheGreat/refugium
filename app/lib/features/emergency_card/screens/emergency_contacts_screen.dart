import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import '../../../core/database/database.dart';
import '../emergency_contacts_provider.dart';

class EmergencyContactsScreen extends ConsumerWidget {
  const EmergencyContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(emergencyContactsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notfallkontakte')),
      body: contactsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(
              child: Text('Noch keine Notfallkontakte eingetragen.'),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            onReorder: (oldIndex, newIndex) async {
              if (newIndex > oldIndex) newIndex--;
              final reordered = [...contacts];
              final item = reordered.removeAt(oldIndex);
              reordered.insert(newIndex, item);
              for (int i = 0; i < reordered.length; i++) {
                await updateEmergencyContact(
                  ref,
                  reordered[i].copyWith(rank: i),
                );
              }
            },
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return _ContactCard(
                key: ValueKey(contact.id),
                contact: contact,
                rank: index + 1,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const AddEditContactDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ContactCard extends ConsumerWidget {
  final EmergencyContactData contact;
  final int rank;

  const _ContactCard({super.key, required this.contact, required this.rank});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  child: Text('$rank', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        contact.relationship,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AddEditContactDialog(contact: contact),
                  ),
                  color: Colors.grey,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () => deleteEmergencyContact(ref, contact.id),
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  contact.phone,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (contact.preferredContactMethod != 'Phone') ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      _methodLabel(contact.preferredContactMethod),
                      style: const TextStyle(fontSize: 10),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ],
            ),
            if (contact.availableHours != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    contact.availableHours!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: [
                if (contact.knowsAboutDiagnosis)
                  const _KnowledgeChip('Diagnose'),
                if (contact.knowsAboutParts) const _KnowledgeChip('Anteile'),
                if (contact.knowsAboutTrauma) const _KnowledgeChip('Trauma'),
              ],
            ),
            if (contact.notes != null) ...[
              const SizedBox(height: 4),
              Text(
                contact.notes!,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _methodLabel(String method) {
    return switch (method) {
      'SMS' => 'SMS',
      'Email' => 'E-Mail',
      'Signal' => 'Signal',
      _ => method,
    };
  }
}

class _KnowledgeChip extends StatelessWidget {
  final String label;
  const _KnowledgeChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: const TextStyle(fontSize: 10)),
      backgroundColor: Colors.green.shade50,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class AddEditContactDialog extends ConsumerStatefulWidget {
  final EmergencyContactData? contact;

  const AddEditContactDialog({super.key, this.contact});

  @override
  ConsumerState<AddEditContactDialog> createState() =>
      _AddEditContactDialogState();
}

class _AddEditContactDialogState extends ConsumerState<AddEditContactDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _hoursController;
  late final TextEditingController _notesController;
  late String _preferredMethod;
  late bool _knowsDiagnosis;
  late bool _knowsParts;
  late bool _knowsTrauma;
  bool _saving = false;

  bool get _isEdit => widget.contact != null;

  @override
  void initState() {
    super.initState();
    final c = widget.contact;
    _nameController = TextEditingController(text: c?.name ?? '');
    _relationshipController = TextEditingController(
      text: c?.relationship ?? '',
    );
    _phoneController = TextEditingController(text: c?.phone ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _hoursController = TextEditingController(text: c?.availableHours ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _preferredMethod = c?.preferredContactMethod ?? 'Phone';
    _knowsDiagnosis = c?.knowsAboutDiagnosis ?? false;
    _knowsParts = c?.knowsAboutParts ?? false;
    _knowsTrauma = c?.knowsAboutTrauma ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _hoursController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _nullIfEmpty(String v) => v.trim().isEmpty ? null : v.trim();

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty)
      return;
    setState(() => _saving = true);

    if (_isEdit) {
      await updateEmergencyContact(
        ref,
        widget.contact!.copyWith(
          name: _nameController.text.trim(),
          relationship: _relationshipController.text.trim(),
          phone: _phoneController.text.trim(),
          email: Value(_nullIfEmpty(_emailController.text)),
          preferredContactMethod: _preferredMethod,
          knowsAboutDiagnosis: _knowsDiagnosis,
          knowsAboutParts: _knowsParts,
          knowsAboutTrauma: _knowsTrauma,
          availableHours: Value(_nullIfEmpty(_hoursController.text)),
          notes: Value(_nullIfEmpty(_notesController.text)),
        ),
      );
    } else {
      await addEmergencyContact(
        ref,
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _nullIfEmpty(_emailController.text),
        preferredContactMethod: _preferredMethod,
        knowsAboutDiagnosis: _knowsDiagnosis,
        knowsAboutParts: _knowsParts,
        knowsAboutTrauma: _knowsTrauma,
        availableHours: _nullIfEmpty(_hoursController.text),
        notes: _nullIfEmpty(_notesController.text),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Kontakt bearbeiten' : 'Kontakt hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field('Name *', _nameController),
            _field(
              'Beziehung *',
              _relationshipController,
              hint: 'z.B. Partner, Mutter, Therapeutin',
            ),
            _field(
              'Telefon *',
              _phoneController,
              keyboard: TextInputType.phone,
            ),
            _field(
              'E-Mail',
              _emailController,
              keyboard: TextInputType.emailAddress,
            ),
            _field('Erreichbar', _hoursController, hint: 'z.B. Mo–Fr 9–18 Uhr'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _preferredMethod,
              decoration: const InputDecoration(
                labelText: 'Bevorzugter Kontaktweg',
              ),
              items: const [
                DropdownMenuItem(value: 'Phone', child: Text('Anruf')),
                DropdownMenuItem(value: 'SMS', child: Text('SMS')),
                DropdownMenuItem(value: 'Email', child: Text('E-Mail')),
                DropdownMenuItem(value: 'Signal', child: Text('Signal')),
              ],
              onChanged: (v) =>
                  setState(() => _preferredMethod = v ?? _preferredMethod),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Wissensstand:', style: TextStyle(fontSize: 12)),
            ),
            CheckboxListTile(
              value: _knowsDiagnosis,
              onChanged: (v) => setState(() => _knowsDiagnosis = v ?? false),
              title: const Text('Kennt die Diagnose'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              value: _knowsParts,
              onChanged: (v) => setState(() => _knowsParts = v ?? false),
              title: const Text('Kennt die Anteile'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            CheckboxListTile(
              value: _knowsTrauma,
              onChanged: (v) => setState(() => _knowsTrauma = v ?? false),
              title: const Text('Kennt das Trauma'),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            _field('Notizen', _notesController, maxLines: 2),
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

  Widget _field(
    String label,
    TextEditingController controller, {
    String? hint,
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }
}
