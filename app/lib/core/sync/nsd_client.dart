import 'package:flutter/services.dart';

const _channel = MethodChannel('com.github.hanzothegreat.refugium/nsd');

class NsdClient {
  static Future<bool> registerService(
    String deviceId, {
    int port = 7890,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('registerService', {
        'deviceId': deviceId,
        'port': port,
      });
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> discoverServices() async {
    try {
      final result = await _channel.invokeMethod<List>('discoverServices');
      return result?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ??
          [];
    } catch (_) {
      return [];
    }
  }

  static Future<void> stopServices() async {
    try {
      await _channel.invokeMethod('stopServices');
    } catch (_) {}
  }
}
