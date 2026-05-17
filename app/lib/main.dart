import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database.dart';
import 'core/database/database_provider.dart';
import 'core/sync/app_mode_provider.dart';
import 'core/sync/connection_provider.dart';
import 'core/sync/sync_service.dart' show SyncService, syncServiceProvider;
import 'core/sync/sync_provider.dart';
import 'core/sync/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/parts/screens/parts_screen.dart';
import 'features/switch_tracker/screens/switch_tracker_screen.dart';
import 'features/switch_tracker/screens/settings_screen.dart';
import 'features/emergency_card/screens/emergency_card_screen.dart';
import 'features/emergency_card/screens/emergency_contacts_screen.dart';
import 'features/emergency_card/screens/medical_record_screen.dart';
import 'features/journal/screens/journal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  final db = await AppDatabase.open();
  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: const RefugiumApp(),
    ),
  );
}

class RefugiumApp extends ConsumerWidget {
  const RefugiumApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncService = ref.read(syncServiceProvider);
    final syncState = ref.watch(syncProvider);
    syncState.whenData((state) {
      syncService.start(ref, 'https://refugium-sync.duckdns.org');
    });

    return MaterialApp(
      title: 'Refugium',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // Folgt System-Einstellung automatisch
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final activeMode = ref.watch(activeModeProvider);
    final connectionsAsync = ref.watch(connectionsProvider);
    final activeConnectionAsync = ref.watch(activeConnectionProvider);

    final screens = _screensForMode(activeMode);
    final destinations = _destinationsForMode(activeMode);
    final safeIndex = _index < screens.length ? _index : 0;

    return Scaffold(
      appBar: AppBar(
        title: _buildTitle(activeConnectionAsync, connectionsAsync, activeMode),
        actions: [
          PopupMenuButton<AppMode>(
            icon: Icon(_modeIcon(activeMode)),
            tooltip: 'Modus wechseln',
            onSelected: (mode) {
              ref.read(activeModeProvider.notifier).setMode(mode);
              setState(() => _index = 0);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: AppMode.patient,
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: activeMode == AppMode.patient
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Betroffene/r'),
                    if (activeMode == AppMode.patient) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: AppMode.partner,
                child: Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: activeMode == AppMode.partner
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Partner/Angehörige/r'),
                    if (activeMode == AppMode.partner) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
              PopupMenuItem(
                value: AppMode.therapist,
                child: Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: activeMode == AppMode.therapist
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    const SizedBox(width: 8),
                    const Text('Therapeut:in'),
                    if (activeMode == AppMode.therapist) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.check, size: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Einstellungen',
            onPressed: () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: screens[safeIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }

  Widget _buildTitle(
    AsyncValue<ConnectionData?> activeConnectionAsync,
    AsyncValue<List<ConnectionData>> connectionsAsync,
    AppMode activeMode,
  ) {
    if (activeMode == AppMode.patient) return const Text('Refugium');

    return connectionsAsync.when(
      loading: () => const Text('Refugium'),
      error: (_, __) => const Text('Refugium'),
      data: (connections) {
        if (connections.isEmpty) return const Text('Refugium');
        final active = activeConnectionAsync.asData?.value;
        return DropdownButton<String>(
          value: active?.id,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.arrow_drop_down),
          items: connections.map((c) {
            return DropdownMenuItem(
              value: c.id,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    c.role == 'therapist'
                        ? Icons.medical_services
                        : Icons.favorite,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(c.remoteDisplayName),
                ],
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) setActiveConnection(ref, id);
          },
          hint: const Text('Verbindung wählen'),
        );
      },
    );
  }

  List<Widget> _screensForMode(AppMode mode) {
    switch (mode) {
      case AppMode.patient:
        return const [
          SwitchTrackerScreen(),
          PartsScreen(),
          EmergencyCardScreen(),
          EmergencyContactsScreen(),
          MedicalRecordScreen(),
          JournalScreen(),
        ];
      case AppMode.partner:
        return const [
          SwitchTrackerScreen(),
          EmergencyCardScreen(),
          JournalScreen(),
        ];
      case AppMode.therapist:
        return const [
          SwitchTrackerScreen(),
          PartsScreen(),
          EmergencyCardScreen(),
          JournalScreen(),
        ];
    }
  }

  List<NavigationDestination> _destinationsForMode(AppMode mode) {
    switch (mode) {
      case AppMode.patient:
        return const [
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Jetzt',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Anteile',
          ),
          NavigationDestination(
            icon: Icon(Icons.emergency_outlined),
            selectedIcon: Icon(Icons.emergency),
            label: 'Notfall',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts),
            label: 'Kontakte',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_information_outlined),
            selectedIcon: Icon(Icons.medical_information),
            label: 'Medizin',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Journal',
          ),
        ];
      case AppMode.partner:
        return const [
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Jetzt',
          ),
          NavigationDestination(
            icon: Icon(Icons.emergency_outlined),
            selectedIcon: Icon(Icons.emergency),
            label: 'Notfall',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Journal',
          ),
        ];
      case AppMode.therapist:
        return const [
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Jetzt',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Anteile',
          ),
          NavigationDestination(
            icon: Icon(Icons.emergency_outlined),
            selectedIcon: Icon(Icons.emergency),
            label: 'Notfall',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
            label: 'Journal',
          ),
        ];
    }
  }

  IconData _modeIcon(AppMode mode) {
    return switch (mode) {
      AppMode.patient => Icons.person,
      AppMode.partner => Icons.favorite,
      AppMode.therapist => Icons.medical_services,
    };
  }
}
