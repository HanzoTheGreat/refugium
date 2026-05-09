import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database.dart';
import 'features/parts/screens/parts_screen.dart';
import 'features/switch_tracker/screens/switch_tracker_screen.dart';
import 'features/emergency_card/screens/emergency_card_screen.dart';
import 'features/emergency_card/screens/emergency_contacts_screen.dart';
import 'features/emergency_card/screens/medical_record_screen.dart';
import 'features/journal/screens/journal_screen.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: RefugiumApp()));
}

class RefugiumApp extends StatelessWidget {
  const RefugiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refugium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B9E87),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    SwitchTrackerScreen(),
    PartsScreen(),
    EmergencyCardScreen(),
    EmergencyContactsScreen(),
    MedicalRecordScreen(),
    JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Jetzt'),
          NavigationDestination(icon: Icon(Icons.people), label: 'Anteile'),
          NavigationDestination(icon: Icon(Icons.emergency), label: 'Notfall'),
          NavigationDestination(icon: Icon(Icons.contacts), label: 'Kontakte'),
          NavigationDestination(
            icon: Icon(Icons.medical_information),
            label: 'Medizin',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}
