import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../parts_provider.dart';
import '../widgets/add_part_dialog.dart';
import '../widgets/part_card.dart';

class PartsScreen extends ConsumerWidget {
  const PartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partsAsync = ref.watch(partsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Anteile')),
      body: partsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Fehler: $e')),
        data: (parts) {
          if (parts.isEmpty) {
            return const Center(
              child: Text(
                'Noch keine Anteile angelegt.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: parts.length,
            itemBuilder: (context, index) {
              return PartCard(part: parts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (_) => const AddPartDialog()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
