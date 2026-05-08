import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../parts/parts_provider.dart';
import '../../parts/consent_provider.dart';
import '../../../core/database/database.dart';
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
                return Column(
                  children: [
                    Container(
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
                    ),
                    if (currentPart != null)
                      _ConsentSummary(partId: currentPart.id),
                  ],
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
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
                ),
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

class _ConsentSummary extends ConsumerWidget {
  final String partId;

  const _ConsentSummary({required this.partId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consentAsync = ref.watch(consentProfileProvider(partId));

    return consentAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (consent) {
        if (consent == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Kein Consent-Profil hinterlegt.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.orange),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Consent', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _ConsentChip('Berührung', consent.touchGeneral),
                  _ConsentChip('Intim', consent.touchIntimate),
                  _ConsentChip('Küssen', consent.kiss),
                  _ConsentChip('Kosenamen', consent.petNames),
                  _ConsentChip('Sex', consent.sexualActivity),
                  _ConsentChip('Autofahren', consent.driving),
                  _ConsentChip('Alkohol', consent.alcohol),
                  _ConsentChip('Finanzen', consent.decisionsFinancial),
                  _ConsentChip('Medizin', consent.decisionsMedical),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConsentChip extends StatelessWidget {
  final String label;
  final String value;

  const _ConsentChip(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (value) {
      'Yes' => (Colors.green.shade100, Icons.check_circle),
      'AskFirst' => (Colors.orange.shade100, Icons.help),
      'No' => (Colors.red.shade100, Icons.cancel),
      _ => (Colors.grey.shade200, Icons.question_mark),
    };

    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: color == Colors.green.shade100
            ? Colors.green.shade700
            : color == Colors.orange.shade100
            ? Colors.orange.shade700
            : color == Colors.red.shade100
            ? Colors.red.shade700
            : Colors.grey,
      ),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
