import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../parts/parts_provider.dart';
import '../switch_tracker_provider.dart';

class SwitchTrackerScreen extends ConsumerWidget {
  const SwitchTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAsync = ref.watch(switchTrackerProvider);
    final partsAsync = ref.watch(partsProvider);
    final historyAsync = ref.watch(switchHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wer ist vorne?')),
      body: Column(
        children: [
          // Aktueller Anteil
          currentAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (current) => partsAsync.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Fehler: $e'),
              data: (parts) {
                final currentPart = current == null
                    ? null
                    : parts.where((p) => p.id == current.partId).firstOrNull;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      Text(
                        'Aktuell vorne',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentPart?.displayName ?? 'Niemand eingeloggt',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (currentPart?.pronouns != null) ...[
                        const SizedBox(height: 4),
                        Text(currentPart!.pronouns!),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Anteil wechseln
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Anteil wechseln',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          partsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (parts) {
              final activeParts = parts
                  .where((p) => p.status == 'Active')
                  .toList();
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: activeParts.map((part) {
                  return ActionChip(
                    label: Text(part.displayName ?? 'Unbenannt'),
                    onPressed: () => ref
                        .read(switchTrackerProvider.notifier)
                        .switchTo(part.id),
                  );
                }).toList(),
              );
            },
          ),

          const Divider(height: 32),

          // History
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Letzte Wechsel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          Expanded(
            child: historyAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
              data: (history) => partsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Fehler: $e')),
                data: (parts) {
                  if (history.isEmpty) {
                    return const Center(child: Text('Noch keine Wechsel'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final event = history[index];
                      final part = parts
                          .where((p) => p.id == event.partId)
                          .firstOrNull;
                      return ListTile(
                        title: Text(part?.displayName ?? 'Unbekannt'),
                        subtitle: Text(_formatTime(event.timestamp)),
                        leading: const Icon(Icons.swap_horiz),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
