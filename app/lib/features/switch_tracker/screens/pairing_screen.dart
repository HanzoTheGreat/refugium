import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/sync/api_client.dart';
import '../../../core/sync/sync_provider.dart';

const _partnerDeviceIdKey = 'refugium_partner_device_id';
const _pairingIdKey = 'refugium_pairing_id';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  final _codeController = TextEditingController();
  String? _generatedCode;
  String? _generatedPairingId;
  bool _isLoading = false;
  String? _error;
  String _selectedRole = 'partner';
  bool _showScanner = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _generateInvite(String deviceId) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      final result = await client.createInvite(deviceId, _selectedRole);
      setState(() {
        _generatedCode = result['invite_code'] as String;
        _generatedPairingId = result['pairing_id'] as String;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _joinWithCode(String deviceId, String code) async {
    if (code.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _showScanner = false;
    });
    try {
      final client = ref.read(apiClientProvider);
      final result = await client.joinPairing(
        code.trim().toUpperCase(),
        deviceId,
      );

      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

      final initiatorId = result['initiator_device_id'] as String;
      final pairingId = result['pairing_id'] as String;

      await storage.write(key: _partnerDeviceIdKey, value: initiatorId);
      await storage.write(key: _pairingIdKey, value: pairingId);

      await client.confirmPairing(pairingId, deviceId);

      ref.invalidate(syncProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verbindung hergestellt!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _confirmInvite(String deviceId) async {
    if (_generatedPairingId == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = ref.read(apiClientProvider);
      await client.confirmPairing(_generatedPairingId!, deviceId);

      const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );
      await storage.write(key: _pairingIdKey, value: _generatedPairingId);

      ref.invalidate(syncProvider);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Verbindung bestätigt!')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncAsync = ref.watch(syncProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Gerät verbinden')),
      body: syncAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
        data: (sync) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Geräte-ID Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deine Geräte-ID',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            sync.deviceId,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 16),
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: sync.deviceId),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Kopiert')),
                            );
                          },
                        ),
                      ],
                    ),
                    if (sync.isPaired)
                      Chip(
                        label: const Text('Verbunden'),
                        backgroundColor: Colors.green.shade100,
                        avatar: const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_error != null) ...[
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Einladung erstellen
            Text(
              'Einladung erstellen',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Rolle des anderen Geräts',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'partner', child: Text('Partner')),
                DropdownMenuItem(
                  value: 'therapist',
                  child: Text('Therapeut:in'),
                ),
              ],
              onChanged: (v) => setState(() => _selectedRole = v ?? 'partner'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _generateInvite(sync.deviceId),
              icon: const Icon(Icons.qr_code),
              label: const Text('Einladungscode generieren'),
            ),

            // Generierter Code + QR
            if (_generatedCode != null) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // QR-Code
                      QrImageView(
                        data: _generatedCode!,
                        version: QrVersions.auto,
                        size: 180,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      // Textcode
                      Text(
                        _generatedCode!,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'QR-Code scannen oder Code eingeben',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Kopieren'),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: _generatedCode!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Code kopiert')),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: _isLoading
                                ? null
                                : () => _confirmInvite(sync.deviceId),
                            child: const Text('Bestätigen'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Divider(height: 40),

            // Mit Code verbinden
            Text(
              'Mit Code verbinden',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),

            // QR-Scanner
            if (_showScanner) ...[
              SizedBox(
                height: 240,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull;
                      if (barcode?.rawValue != null) {
                        _joinWithCode(sync.deviceId, barcode!.rawValue!);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() => _showScanner = false),
                child: const Text('Scanner schließen'),
              ),
              const SizedBox(height: 8),
            ] else ...[
              OutlinedButton.icon(
                onPressed: () => setState(() => _showScanner = true),
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('QR-Code scannen'),
              ),
              const SizedBox(height: 8),
            ],

            // Manuelle Eingabe
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Code manuell eingeben',
                border: OutlineInputBorder(),
                hintText: 'z.B. 1ZAGT51I',
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 8,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _isLoading
                  ? null
                  : () => _joinWithCode(sync.deviceId, _codeController.text),
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.link),
              label: const Text('Verbinden'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
