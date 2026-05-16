import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  // ÄNDERUNG: deviceId wird mitgeschickt → Server kann ON CONFLICT idempotent reagieren.
  Future<Map<String, dynamic>> registerDevice(
    String deviceId,
    String publicKey,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/devices/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'device_id': deviceId, 'public_key': publicKey}),
    );
    if (response.statusCode != 200) {
      throw Exception('Registrierung fehlgeschlagen: ${response.body}');
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> createInvite(
    String deviceId,
    String role,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/pairs/invite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'device_id': deviceId, 'role': role}),
    );
    if (response.statusCode != 200) {
      throw Exception('Invite fehlgeschlagen: ${response.body}');
    }
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> joinPairing(
    String inviteCode,
    String deviceId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/pairs/join'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'invite_code': inviteCode, 'device_id': deviceId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Join fehlgeschlagen: ${response.body}');
    }
    return jsonDecode(response.body);
  }

  Future<void> confirmPairing(String pairingId, String deviceId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/pairs/confirm'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pairing_id': pairingId, 'device_id': deviceId}),
    );
    if (response.statusCode != 200) {
      throw Exception('Confirm fehlgeschlagen: ${response.body}');
    }
  }

  Future<void> sendMessage({
    required String senderDeviceId,
    required String recipientDeviceId,
    required String payload,
    required String messageType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/messages/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sender_device_id': senderDeviceId,
        'recipient_device_id': recipientDeviceId,
        'payload': payload,
        'message_type': messageType,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Nachricht fehlgeschlagen: ${response.body}');
    }
  }

  Future<List<dynamic>> fetchMessages(String deviceId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/v1/messages/$deviceId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Fetch fehlgeschlagen: ${response.body}');
    }
    return jsonDecode(response.body);
  }

  Future<void> registerPush(String deviceId, String ntfyTopic) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/v1/push/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'device_id': deviceId, 'ntfy_topic': ntfyTopic}),
    );
    if (response.statusCode != 200) {
      throw Exception('Push-Registrierung fehlgeschlagen: ${response.body}');
    }
  }
}
