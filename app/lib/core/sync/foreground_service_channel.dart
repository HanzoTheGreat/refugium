import 'dart:io';
import 'package:flutter/services.dart';

/// Steuert den Android ForegroundService und empfängt triggerSync-Callbacks.
/// Nur auf Android aktiv – auf anderen Plattformen no-op.
class ForegroundServiceChannel {
  static const _channel = MethodChannel(
    'com.github.hanzothegreat.refugium/sync',
  );
  static bool _initialized = false;

  /// Muss einmalig aufgerufen werden, bevor startService genutzt wird.
  /// [onTriggerSync]: wird aufgerufen wenn der ForegroundService einen SSE-Ping
  /// empfangen hat und Dart den Poll ausführen soll.
  static void init({required Future<void> Function() onTriggerSync}) {
    if (!Platform.isAndroid) return;
    if (_initialized) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'triggerSync') {
        await onTriggerSync();
      }
    });
  }

  /// Startet den Foreground Service mit der gegebenen Device-ID.
  static Future<void> startService(String deviceId) async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('startForegroundService', {
        'deviceId': deviceId,
      });
    } catch (_) {}
  }

  /// Stoppt den Foreground Service.
  static Future<void> stopService() async {
    if (!Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('stopForegroundService');
    } catch (_) {}
  }
}
