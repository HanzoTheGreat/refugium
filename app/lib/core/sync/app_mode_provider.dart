import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AppMode { patient, partner, therapist }

const _ownModeKey = 'refugium_own_mode';

final ownModeProvider = FutureProvider<AppMode>((ref) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  final stored = await storage.read(key: _ownModeKey);
  return switch (stored) {
    'partner' => AppMode.partner,
    'therapist' => AppMode.therapist,
    _ => AppMode.patient,
  };
});

final activeModeProvider = NotifierProvider<ActiveModeNotifier, AppMode>(
  ActiveModeNotifier.new,
);

class ActiveModeNotifier extends Notifier<AppMode> {
  @override
  AppMode build() {
    final ownModeAsync = ref.watch(ownModeProvider);
    return ownModeAsync.when(
      data: (mode) => mode,
      loading: () => AppMode.patient,
      error: (_, __) => AppMode.patient,
    );
  }

  void setMode(AppMode mode) => state = mode;

  void resetToOwn() {
    final ownModeAsync = ref.read(ownModeProvider);
    state = ownModeAsync.when(
      data: (mode) => mode,
      loading: () => AppMode.patient,
      error: (_, __) => AppMode.patient,
    );
  }
}

Future<void> saveOwnMode(AppMode mode) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  await storage.write(key: _ownModeKey, value: mode.name);
}
