import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);

const _privateKeyStorageKey = 'refugium_x25519_private';
const _publicKeyStorageKey = 'refugium_x25519_public';
const _sharedSecretKeyPrefix = 'refugium_shared_secret_';

class CryptoService {
  static final _x25519 = X25519();
  static final _aesGcm = AesGcm.with256bits();

  /// Keypair beim ersten Start generieren und persistieren
  static Future<SimpleKeyPair> getOrCreateKeyPair() async {
    final storedPrivate = await _storage.read(key: _privateKeyStorageKey);
    final storedPublic = await _storage.read(key: _publicKeyStorageKey);

    if (storedPrivate != null && storedPublic != null) {
      final privateBytes = base64Decode(storedPrivate);
      final publicBytes = base64Decode(storedPublic);
      return SimpleKeyPairData(
        privateBytes,
        publicKey: SimplePublicKey(publicBytes, type: KeyPairType.x25519),
        type: KeyPairType.x25519,
      );
    }

    final keyPair = await _x25519.newKeyPair();
    final privateBytes = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();

    await _storage.write(
      key: _privateKeyStorageKey,
      value: base64Encode(privateBytes),
    );
    await _storage.write(
      key: _publicKeyStorageKey,
      value: base64Encode(publicKey.bytes),
    );

    return keyPair;
  }

  /// Eigenen Public Key als Base64 zurückgeben
  static Future<String> getPublicKeyBase64() async {
    final stored = await _storage.read(key: _publicKeyStorageKey);
    if (stored != null) return stored;
    final keyPair = await getOrCreateKeyPair();
    final publicKey = await keyPair.extractPublicKey();
    return base64Encode(publicKey.bytes);
  }

  /// Shared Secret mit Partner-Public-Key ableiten und speichern
  static Future<void> deriveAndStoreSharedSecret(
    String connectionId,
    String partnerPublicKeyBase64,
  ) async {
    final keyPair = await getOrCreateKeyPair();
    final partnerPublicBytes = base64Decode(partnerPublicKeyBase64);
    final partnerPublicKey = SimplePublicKey(
      partnerPublicBytes,
      type: KeyPairType.x25519,
    );

    final sharedSecret = await _x25519.sharedSecretKey(
      keyPair: keyPair,
      remotePublicKey: partnerPublicKey,
    );
    final sharedSecretBytes = await sharedSecret.extractBytes();

    await _storage.write(
      key: '$_sharedSecretKeyPrefix$connectionId',
      value: base64Encode(sharedSecretBytes),
    );
  }

  /// Payload verschlüsseln
  static Future<String> encrypt(String plaintext, String connectionId) async {
    final sharedSecretBase64 = await _storage.read(
      key: '$_sharedSecretKeyPrefix$connectionId',
    );

    if (sharedSecretBase64 == null) {
      // Noch kein Shared Secret – Plaintext mit Marker zurückgeben
      return 'plain:$plaintext';
    }

    final keyBytes = base64Decode(sharedSecretBase64);
    final secretKey = SecretKey(keyBytes);
    final nonce = _aesGcm.newNonce();

    final secretBox = await _aesGcm.encrypt(
      utf8.encode(plaintext),
      secretKey: secretKey,
      nonce: nonce,
    );

    final combined = {
      'v': 1,
      'n': base64Encode(secretBox.nonce),
      'c': base64Encode(secretBox.cipherText),
      'm': base64Encode(secretBox.mac.bytes),
    };

    return 'enc:${jsonEncode(combined)}';
  }

  /// Payload entschlüsseln
  static Future<String> decrypt(String payload, String connectionId) async {
    if (payload.startsWith('plain:')) {
      return payload.substring(6);
    }

    if (!payload.startsWith('enc:')) {
      // Kein bekanntes Format – as-is zurückgeben
      return payload;
    }

    final sharedSecretBase64 = await _storage.read(
      key: '$_sharedSecretKeyPrefix$connectionId',
    );

    if (sharedSecretBase64 == null) {
      throw Exception('Kein Shared Secret für Verbindung $connectionId');
    }

    final keyBytes = base64Decode(sharedSecretBase64);
    final secretKey = SecretKey(keyBytes);

    final data = jsonDecode(payload.substring(4)) as Map<String, dynamic>;
    final nonce = base64Decode(data['n'] as String);
    final cipherText = base64Decode(data['c'] as String);
    final mac = Mac(base64Decode(data['m'] as String));

    final secretBox = SecretBox(cipherText, nonce: nonce, mac: mac);
    final decrypted = await _aesGcm.decrypt(secretBox, secretKey: secretKey);

    return utf8.decode(decrypted);
  }

  /// Shared Secret für eine Verbindung löschen
  static Future<void> deleteSharedSecret(String connectionId) async {
    await _storage.delete(key: '$_sharedSecretKeyPrefix$connectionId');
  }
}
