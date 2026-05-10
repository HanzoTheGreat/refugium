import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'api_client.dart';

const _serverUrl = 'http://65.108.149.162:8080';
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

  final pairingId = await storage.read(key: _pairingIdKey);
  final partnerDeviceId = await storage.read(key: _partnerDeviceIdKey);

  return SyncState(
    deviceId: deviceId,
    pairingId: pairingId,
    partnerDeviceId: partnerDeviceId,
    isPaired: partnerDeviceId != null,
  );
});

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
