import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../parts/parts_provider.dart';
import '../journal_provider.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(journalEntriesProvider);
    final partsAsync = ref.watch(partsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('Noch keine Einträge.'));
          }
          return partsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
            data: (parts) => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final part = entry.partId != null
                    ? parts.where((p) => p.id == entry.partId).firstOrNull
                    : null;
                return _JournalCard(entry: entry, part: part);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => const _WriteEntrySheet(),
        ),
        child: const Icon(Icons.edit),
      ),
    );
  }
}

class _JournalCard extends ConsumerWidget {
  final JournalEntryData entry;
  final PartsData? part;

  const _JournalCard({required this.entry, this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => _WriteEntrySheet(entry: entry),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (part != null) ...[
                    CircleAvatar(
                      radius: 12,
                      child: Text(
                        (part!.displayName ?? '?')[0].toUpperCase(),
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      part!.displayName ?? 'Unbenannt',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    const Icon(Icons.person_outline, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Kein Anteil',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                  const Spacer(),
                  if (entry.mood != null)
                    Text(entry.mood!, style: const TextStyle(fontSize: 18)),
                  if (entry.isPrivate) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(entry.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    onPressed: () => deleteJournalEntry(ref, entry.id),
                    color: Colors.grey,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(entry.content),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _WriteEntrySheet extends ConsumerStatefulWidget {
  final JournalEntryData? entry;

  const _WriteEntrySheet({this.entry});

  @override
  ConsumerState<_WriteEntrySheet> createState() => _WriteEntrySheetState();
}

class _WriteEntrySheetState extends ConsumerState<_WriteEntrySheet> {
  late final TextEditingController _contentController;
  String? _selectedPartId;
  String? _selectedMood;
  bool _isPrivate = false;
  bool _saving = false;

  bool get _isEdit => widget.entry != null;

  static const _moods = ['😊', '😔', '😰', '😤', '😶', '🌀', '💙'];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.entry?.content ?? '',
    );
    _selectedPartId = widget.entry?.partId;
    _selectedMood = widget.entry?.mood;
    _isPrivate = widget.entry?.isPrivate ?? false;
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() => _saving = true);
    if (_isEdit) {
      await updateJournalEntry(
        ref,
        id: widget.entry!.id,
        content: _contentController.text.trim(),
        mood: _selectedMood,
        isPrivate: _isPrivate,
      );
    } else {
      await addJournalEntry(
        ref,
        partId: _selectedPartId,
        content: _contentController.text.trim(),
        mood: _selectedMood,
        isPrivate: _isPrivate,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final partsAsync = ref.watch(partsProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                _isEdit ? 'Eintrag bearbeiten' : 'Neuer Eintrag',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
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
          const SizedBox(height: 8),

          // Anteil wählen
          partsAsync.maybeWhen(
            data: (parts) => DropdownButtonFormField<String?>(
              initialValue: _selectedPartId,
              decoration: const InputDecoration(labelText: 'Anteil (optional)'),
              items: [
                const DropdownMenuItem(value: null, child: Text('Kein Anteil')),
                ...parts
                    .where((p) => p.status == 'Active')
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.displayName ?? 'Unbenannt'),
                      ),
                    ),
              ],
              onChanged: (v) => setState(() => _selectedPartId = v),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 8),

          // Stimmung
          Row(
            children: [
              Text('Stimmung:', style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(width: 8),
              ..._moods.map(
                (mood) => GestureDetector(
                  onTap: () => setState(
                    () => _selectedMood = _selectedMood == mood ? null : mood,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _selectedMood == mood
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(mood, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Inhalt
          TextField(
            controller: _contentController,
            maxLines: 6,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Was möchtest du festhalten?',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),

          // Privat
          SwitchListTile(
            value: _isPrivate,
            onChanged: (v) => setState(() => _isPrivate = v),
            title: const Text('Privat'),
            subtitle: const Text('Nur intern sichtbar'),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ],
      ),
    );
  }
}
