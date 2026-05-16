import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../parts/parts_provider.dart';
import '../../parts/consent_provider.dart';
import '../switch_tracker_provider.dart';
import '../../../core/sync/app_mode_provider.dart';
import '../../../core/sync/connection_provider.dart';
import '../../../core/sync/sync_service.dart';

class SwitchTrackerScreen extends ConsumerWidget {
  const SwitchTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(activeModeProvider);
    final isPatient = mode == AppMode.patient;

    if (isPatient) {
      return const _PatientSwitchTracker();
    } else {
      return const _PartnerSwitchTracker();
    }
  }
}

// Patient-Modus: lokale Daten, kann einchecken
class _PatientSwitchTracker extends ConsumerWidget {
  const _PatientSwitchTracker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAsync = ref.watch(currentPartProvider);
    final partsAsync = ref.watch(partsProvider);
    final historyAsync = ref.watch(switchHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Wer ist vorne?')),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: currentAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Fehler: $e'),
              ),
              data: (current) => partsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Fehler: $e'),
                ),
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Anteil wechseln',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: partsAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => const SizedBox.shrink(),
              data: (parts) {
                final activeParts = parts
                    .where((p) => p.status == 'Active')
                    .toList();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: activeParts
                        .map(
                          (part) => ActionChip(
                            label: Text(part.displayName ?? 'Unbenannt'),
                            onPressed: () => ref
                                .read(switchTrackerProvider.notifier)
                                .switchTo(part.id),
                          ),
                        )
                        .toList(),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 32)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Letzte Wechsel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          historyAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SliverToBoxAdapter(child: Center(child: Text('Fehler: $e'))),
            data: (history) => partsAsync.when(
              loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (e, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              data: (parts) {
                if (history.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: Text('Noch keine Wechsel')),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final event = history[index];
                    final part = parts
                        .where((p) => p.id == event.partId)
                        .firstOrNull;
                    return ListTile(
                      title: Text(part?.displayName ?? 'Unbekannt'),
                      subtitle: Text(_formatTime(event.timestamp)),
                      leading: const Icon(Icons.swap_horiz),
                    );
                  }, childCount: history.length),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// Partner/Therapeut-Modus: Remote-Daten, nur lesen + Sync anfordern
class _PartnerSwitchTracker extends ConsumerStatefulWidget {
  const _PartnerSwitchTracker();

  @override
  ConsumerState<_PartnerSwitchTracker> createState() =>
      _PartnerSwitchTrackerState();
}

class _PartnerSwitchTrackerState extends ConsumerState<_PartnerSwitchTracker> {
  bool _requesting = false;

  Future<void> _requestSync(String remoteDeviceId) async {
    setState(() => _requesting = true);
    try {
      await SyncService().sendSyncEvent(
        recipientDeviceId: remoteDeviceId,
        messageType: 'SyncRequest',
        payload: {},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anfrage gesendet – Daten kommen gleich.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fehler: $e')));
      }
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentAsync = ref.watch(remoteCurrentPartProvider);
    final historyAsync = ref.watch(remoteSwitchHistoryProvider);
    final connectionsAsync = ref.watch(connectionsProvider);

    final activeConnection = connectionsAsync.asData?.value
        .where((c) => c.isActive)
        .firstOrNull;
    final connectionName =
        activeConnection?.remoteDisplayName ?? 'Verbundenes System';
    final remoteDeviceId = activeConnection?.remoteDeviceId;

    return Scaffold(
      appBar: AppBar(title: Text('Wer ist vorne? · $connectionName')),
      body: CustomScrollView(
        slivers: [
          // Aktueller Anteil (remote)
          SliverToBoxAdapter(
            child: currentAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Fehler: $e'),
              ),
              data: (current) {
                final partName =
                    current?.remotePartName ??
                    current?.partId ??
                    'Noch kein Einchecken';
                final hasData = current != null;

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
                        hasData ? partName : 'Noch kein Einchecken',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      if (hasData) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Zuletzt: ${_formatTime(current!.timestamp)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Sync-Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: FilledButton.tonal(
                onPressed: remoteDeviceId == null || _requesting
                    ? null
                    : () => _requestSync(remoteDeviceId),
                child: _requesting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sync, size: 18),
                          const SizedBox(width: 8),
                          Text('Daten von $connectionName anfordern'),
                        ],
                      ),
              ),
            ),
          ),

          // Info-Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Echtzeit-Updates kommen automatisch beim Einchecken.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: Divider(height: 24)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Letzte Wechsel',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),

          historyAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) =>
                SliverToBoxAdapter(child: Center(child: Text('Fehler: $e'))),
            data: (history) {
              if (history.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text('Noch keine Wechsel empfangen')),
                  ),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final event = history[index];
                  final name = event.remotePartName ?? event.partId;
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(_formatTime(event.timestamp)),
                    leading: const Icon(Icons.swap_horiz),
                  );
                }, childCount: history.length),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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

    final iconColor = switch (value) {
      'Yes' => Colors.green.shade700,
      'AskFirst' => Colors.orange.shade700,
      'No' => Colors.red.shade700,
      _ => Colors.grey,
    };

    return Chip(
      avatar: Icon(icon, size: 16, color: iconColor),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
