import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database.dart';
import '../parts_provider.dart';

class PartDetailScreen extends ConsumerWidget {
  final PartsData part;

  const PartDetailScreen({super.key, required this.part});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(part.displayName ?? 'Unbenannt'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              await ref
                  .read(partsProvider.notifier)
                  .setPartStatus(part.id, value);
              if (context.mounted) Navigator.of(context).pop();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Active', child: Text('Aktiv')),
              PopupMenuItem(value: 'Dormant', child: Text('Ruhend')),
              PopupMenuItem(value: 'Integrated', child: Text('Integriert')),
              PopupMenuItem(value: 'Hypothetical', child: Text('Hypothetisch')),
            ],
          ),
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
        ],
      ),
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
