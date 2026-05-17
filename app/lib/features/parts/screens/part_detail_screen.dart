import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../../../core/sync/app_mode_provider.dart';
import '../parts_provider.dart';
import 'edit_part_screen.dart';
import 'consent_screen.dart';
import 'trigger_screen.dart';

class PartDetailScreen extends ConsumerWidget {
  final String partId;

  const PartDetailScreen({super.key, required this.partId});

  Future<void> _confirmArchive(
    BuildContext context,
    WidgetRef ref,
    PartsData part,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Anteil archivieren?'),
        content: Text(
          '${part.displayName ?? 'Dieser Anteil'} wird auf "Ruhend" gesetzt '
          'und erscheint nicht mehr in der Hauptliste. '
          'Die Daten bleiben vollständig erhalten – '
          'der Anteil kann jederzeit wieder aktiviert werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Archivieren'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await ref.read(partsProvider.notifier).setPartStatus(part.id, 'Dormant');
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    PartsData part,
  ) async {
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Anteil endgültig löschen?'),
        content: Text(
          'Alle Daten von "${part.displayName ?? 'diesem Anteil'}" werden '
          'unwiderruflich gelöscht – Trigger, Consent-Profil, alles.\n\n'
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (firstConfirm != true || !context.mounted) return;

    // Zweite Stufe: Name eintippen
    final nameController = TextEditingController();
    final expectedName = part.displayName ?? '';
    final confirmToken = expectedName.isNotEmpty ? expectedName : 'löschen';
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Sicher?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gib "$confirmToken" ein um zu bestätigen.'),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(ctx).colorScheme.error,
              ),
              onPressed: nameController.text == confirmToken
                  ? () => Navigator.of(ctx).pop(true)
                  : null,
              child: const Text('Endgültig löschen'),
            ),
          ],
        ),
      ),
    );
    if (secondConfirm == true && context.mounted) {
      await ref.read(partsProvider.notifier).deletePart(part.id);
      // Kein manueller pop() – Stream feuert, part == null,
      // addPostFrameCallback in build() navigiert zurück.
      // Doppel-pop → schwarzer Screen.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(partsProvider);
    final mode = ref.watch(activeModeProvider);
    final canEdit = mode == AppMode.patient;

    return partsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Fehler: $e'))),
      data: (parts) {
        final part = parts.where((p) => p.id == partId).firstOrNull;
        // Anteil wurde gelöscht während Screen offen – automatisch zurück
        if (part == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.of(context).pop();
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(part.displayName ?? 'Unbenannt'),
            actions: [
              if (canEdit) ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditPartScreen(part: part),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case '_archive':
                        await _confirmArchive(context, ref, part);
                      case '_delete':
                        await _confirmDelete(context, ref, part);
                      default:
                        await ref
                            .read(partsProvider.notifier)
                            .setPartStatus(part.id, value);
                        if (context.mounted) Navigator.of(context).pop();
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(value: 'Active', child: Text('Aktiv')),
                    const PopupMenuItem(
                      value: 'Integrated',
                      child: Text('Integriert'),
                    ),
                    const PopupMenuItem(
                      value: 'Hypothetical',
                      child: Text('Hypothetisch'),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: '_archive',
                      child: Text('Archivieren (Ruhend)'),
                    ),
                    PopupMenuItem(
                      value: '_delete',
                      child: Text(
                        'Endgültig löschen',
                        style: TextStyle(
                          color: Theme.of(ctx).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Section(
                title: 'Allgemein',
                children: [
                  _Field('Name', part.displayName),
                  _Field('Pronomen', part.pronouns),
                  _Field('Ungefähres Alter', part.apparentAge),
                  _Field('Rolle', part.role),
                  _Field('Status', part.status),
                  _Field('Sichtbarkeit', part.visibility),
                ],
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Beschreibung (intern)',
                children: [_Field(null, part.descriptionInternal)],
              ),
              const SizedBox(height: 16),
              _Section(
                title: 'Beschreibung (extern)',
                children: [_Field(null, part.descriptionExternal)],
              ),
              if (canEdit) ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConsentScreen(
                        partId: part.id,
                        partName: part.displayName ?? 'Unbenannt',
                      ),
                    ),
                  ),
                  child: const Text('Consent-Profil bearbeiten'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TriggerScreen(
                        partId: part.id,
                        partName: part.displayName ?? 'Unbenannt',
                      ),
                    ),
                  ),
                  child: const Text('Trigger bearbeiten'),
                ),
              ] else ...[
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ConsentScreen(
                        partId: part.id,
                        partName: part.displayName ?? 'Unbenannt',
                      ),
                    ),
                  ),
                  child: const Text('Consent-Profil ansehen'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonal(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => TriggerScreen(
                        partId: part.id,
                        partName: part.displayName ?? 'Unbenannt',
                      ),
                    ),
                  ),
                  child: const Text('Trigger ansehen'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String? label;
  final String? value;

  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            SizedBox(
              width: 120,
              child: Text(label!, style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
          Expanded(child: Text(value!)),
        ],
      ),
    );
  }
}
