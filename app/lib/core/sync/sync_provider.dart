import 'package:drift/drift.dart' as drift;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'api_client.dart';
import '../crypto/crypto_service.dart';
import '../database/database.dart';
import '../database/database_provider.dart';

const _serverUrl = 'https://refugium-sync.duckdns.org';
const _deviceIdKey = 'refugium_device_id';
const _pairingIdKey = 'refugium_pairing_id';
const _partnerDeviceIdKey = 'refugium_partner_device_id';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: _serverUrl);
});

final syncProvider = FutureProvider<SyncState>((ref) async {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  String? deviceId = await storage.read(key: _deviceIdKey);

  if (deviceId == null) {
    final client = ref.read(apiClientProvider);
    final publicKey = const Uuid().v4();
    final result = await client.registerDevice(publicKey);
    deviceId = result['device_id'] as String;
    await storage.write(key: _deviceIdKey, value: deviceId);
  }

  // Keypair beim Start sicherstellen
  await CryptoService.getOrCreateKeyPair();

  final pairingId = await storage.read(key: _pairingIdKey);
  final partnerDeviceId = await storage.read(key: _partnerDeviceIdKey);

  if (partnerDeviceId != null) {
    await _migrateOldPairing(ref, partnerDeviceId);
  }

  return SyncState(
    deviceId: deviceId,
    pairingId: pairingId,
    partnerDeviceId: partnerDeviceId,
    isPaired: partnerDeviceId != null,
  );
});

Future<void> _migrateOldPairing(Ref ref, String partnerDeviceId) async {
  try {
    final db = ref.read(databaseProvider);
    final existing = await db.select(db.connections).get();
    if (existing.isNotEmpty) return;

    await db
        .into(db.connections)
        .insert(
          ConnectionsCompanion.insert(
            remoteDeviceId: partnerDeviceId,
            remoteDisplayName: 'Verbundenes Gerät',
            role: const drift.Value('partner'),
            isActive: const drift.Value(true),
          ),
        );
  } catch (_) {}
}

class SyncState {
  final String deviceId;
  final String? pairingId;
  final String? partnerDeviceId;
  final bool isPaired;

  const SyncState({
    required this.deviceId,
    this.pairingId,
    this.partnerDeviceId,
    required this.isPaired,
  });
}
