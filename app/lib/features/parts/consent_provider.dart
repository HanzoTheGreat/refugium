import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/database/database.dart';
import '../../../core/database/database_provider.dart';

final consentProfileProvider =
    FutureProvider.family<ConsentProfileData?, String>((ref, partId) async {
      final db = ref.watch(databaseProvider);
      final query = db.select(db.consentProfiles)
        ..where((t) => t.partId.equals(partId));
      final results = await query.get();
      return results.isEmpty ? null : results.first;
    });

Future<void> upsertConsent(
  WidgetRef ref,
  ConsentProfilesCompanion companion,
) async {
  final db = ref.read(databaseProvider);
  await db.into(db.consentProfiles).insertOnConflictUpdate(companion);
  ref.invalidate(consentProfileProvider(companion.partId.value));
}
