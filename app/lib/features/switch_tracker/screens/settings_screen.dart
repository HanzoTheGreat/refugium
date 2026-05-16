import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/backup/backup_service.dart';
import '../../../core/sync/app_mode_provider.dart';
import '../../../core/sync/connection_provider.dart';
import '../../../core/sync/full_sync_service.dart';
import '../../../core/sync/sync_provider.dart';
import '../../../core/sync/sync_service.dart'
    show SyncService, syncServiceProvider;
import '../../../core/database/database.dart';
import '../../../core/database/database_provider.dart';
import 'pairing_screen.dart';

const _serverUrl = 'https://refugium-sync.duckdns.org';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(activeModeProvider);
    final syncAsync = ref.watch(syncProvider);
    final connectionsAsync = ref.watch(connectionsProvider);
    final activeConnectionAsync = ref.watch(activeConnectionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Geräte-Info
          syncAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (sync) => Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gerät',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sync.deviceId,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          sync.isPaired ? Icons.link : Icons.link_off,
                          size: 16,
                          color: sync.isPaired ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          sync.isPaired ? 'Verbunden' : 'Nicht verbunden',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Modus
          Text('Modus', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                RadioListTile<AppMode>(
                  value: AppMode.patient,
                  groupValue: mode,
                  onChanged: (v) {
                    if (v != null)
                      ref.read(activeModeProvider.notifier).setMode(v);
                  },
                  title: const Text('Betroffene/r'),
                  subtitle: const Text('Voller Zugriff'),
                  secondary: const Icon(Icons.person),
                ),
                RadioListTile<AppMode>(
                  value: AppMode.partner,
                  groupValue: mode,
                  onChanged: (v) {
                    if (v != null)
                      ref.read(activeModeProvider.notifier).setMode(v);
                  },
                  title: const Text('Partner/Angehörige/r'),
                  subtitle: const Text('Nur-Lese-Ansicht'),
                  secondary: const Icon(Icons.favorite),
                ),
                RadioListTile<AppMode>(
                  value: AppMode.therapist,
                  groupValue: mode,
                  onChanged: (v) {
                    if (v != null)
                      ref.read(activeModeProvider.notifier).setMode(v);
                  },
                  title: const Text('Therapeut:in'),
                  subtitle: const Text('Nur-Lese-Ansicht'),
                  secondary: const Icon(Icons.medical_services),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Verbindungen
          Text('Verbindungen', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          connectionsAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Fehler: $e'),
            data: (connections) {
              final active = activeConnectionAsync.asData?.value;
              final activeRemoteDeviceId = active?.remoteDeviceId;
              final activeDisplayName =
                  active?.remoteDisplayName ?? 'Verbundenes System';

              return Card(
                child: Column(
                  children: [
                    if (connections.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Keine Verbindungen vorhanden.'),
                      )
                    else
                      ...connections.map((c) {
                        final isActive = c.id == active?.id;
                        return ListTile(
                          leading: Icon(
                            c.role == 'therapist'
                                ? Icons.medical_services
                                : Icons.favorite,
                            color: isActive ? Colors.green : null,
                          ),
                          title: Text(c.remoteDisplayName),
                          subtitle: Text(
                            c.role == 'therapist'
                                ? 'Therapeut:in'
                                : 'Partner/Angehörige/r',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isActive)
                                const Chip(
                                  label: Text(
                                    'Aktiv',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: Colors.green,
                                  labelStyle: TextStyle(color: Colors.white),
                                  padding: EdgeInsets.zero,
                                )
                              else
                                TextButton(
                                  onPressed: () =>
                                      setActiveConnection(ref, c.id),
                                  child: const Text('Aktivieren'),
                                ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 20),
                                tooltip: 'Umbenennen',
                                onPressed: () => _renameConnection(
                                  context,
                                  ref,
                                  c.id,
                                  c.remoteDisplayName,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.link_off,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                tooltip: 'Verbindung trennen',
                                onPressed: () => _confirmDisconnect(
                                  context,
                                  ref,
                                  c.id,
                                  c.remoteDisplayName,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.add_link),
                      title: const Text('Gerät verbinden'),
                      subtitle: const Text('Pairing via QR-Code oder Code'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PairingScreen(),
                        ),
                      ),
                    ),

                    // Patient: Daten jetzt senden
                    if (mode == AppMode.patient) ...[
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.sync),
                        title: const Text('Daten jetzt synchronisieren'),
                        subtitle: const Text(
                          'Sendet aktuelle Daten an alle verbundenen Geräte',
                        ),
                        onTap: () async {
                          await sendFullSync(ref);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Sync wird gesendet...'),
                              ),
                            );
                          }
                        },
                      ),
                    ],

                    // Angehörige/Therapeut: Daten beim Patienten anfordern
                    if (mode != AppMode.patient &&
                        activeRemoteDeviceId != null) ...[
                      const Divider(height: 1),
                      _RequestSyncTile(
                        remoteDeviceId: activeRemoteDeviceId,
                        displayName: activeDisplayName,
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Backup
          Text('Backup', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.upload),
                  title: const Text('Daten exportieren'),
                  subtitle: const Text('Backup als JSON-Datei speichern'),
                  onTap: () => BackupService.exportBackup(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Daten importieren'),
                  subtitle: const Text(
                    'Backup aus JSON-Datei wiederherstellen',
                  ),
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                    );
                    if (result != null && result.files.single.path != null) {
                      final file = File(result.files.single.path!);
                      final content = await file.readAsString();
                      if (context.mounted) {
                        await BackupService.importBackup(context, ref, content);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _renameConnection(
    BuildContext context,
    WidgetRef ref,
    String connectionId,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verbindung umbenennen'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != currentName) {
      final db = ref.read(databaseProvider);
      await (db.update(db.connections)..where((t) => t.id.equals(connectionId)))
          .write(ConnectionsCompanion(remoteDisplayName: Value(newName)));
    }
  }

  Future<void> _confirmDisconnect(
    BuildContext context,
    WidgetRef ref,
    String connectionId,
    String displayName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Verbindung trennen'),
        content: Text(
          'Verbindung mit "$displayName" wirklich trennen? '
          'Diese Aktion kann nicht rückgängig gemacht werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Trennen'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final syncState = ref.read(syncProvider).asData?.value;
      final deviceId = syncState?.deviceId ?? '';
      final connections = ref.read(connectionsProvider).asData?.value ?? [];
      final connection = connections
          .where((c) => c.id == connectionId)
          .firstOrNull;
      if (connection != null) {
        await disconnectAndNotify(ref, connection, deviceId, _serverUrl);
      } else {
        await deleteConnection(ref, connectionId);
      }
    }
  }
}

/// Eigenes StatefulWidget damit der Ladezustand lokal bleibt
/// und nicht den gesamten Settings-Screen neu baut.
class _RequestSyncTile extends ConsumerStatefulWidget {
  final String remoteDeviceId;
  final String displayName;

  const _RequestSyncTile({
    required this.remoteDeviceId,
    required this.displayName,
  });

  @override
  ConsumerState<_RequestSyncTile> createState() => _RequestSyncTileState();
}

class _RequestSyncTileState extends ConsumerState<_RequestSyncTile> {
  bool _requesting = false;

  Future<void> _request() async {
    setState(() => _requesting = true);
    try {
      await SyncService().sendSyncEvent(
        recipientDeviceId: widget.remoteDeviceId,
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
    return ListTile(
      leading: _requesting
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.sync),
      title: const Text('Daten anfordern'),
      subtitle: Text('Aktuellen Datensatz von ${widget.displayName} holen'),
      enabled: !_requesting,
      onTap: _requesting ? null : _request,
    );
  }
}
