import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/database/database.dart';

// Globaler DB-Provider
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
          seedColor: const Color(0xFF7B9E87), // ruhiges Grün
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      body: Center(
        child: Text(
          'Refugium',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
