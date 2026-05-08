import 'package:flutter/material.dart';
import '../../../core/database/database.dart';

class PartCard extends StatelessWidget {
  final PartsData part;

  const PartCard({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              part.displayName ?? 'Unbenannt',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (part.pronouns != null) ...[
              const SizedBox(height: 4),
              Text(
                part.pronouns!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (part.role != null) ...[
              const SizedBox(height: 4),
              Text(part.role!),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(part.status), padding: EdgeInsets.zero),
                const SizedBox(width: 8),
                Chip(label: Text(part.visibility), padding: EdgeInsets.zero),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
