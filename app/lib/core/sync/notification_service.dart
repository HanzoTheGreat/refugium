import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);
    _initialized = true;
  }

  static Future<void> showSwitchNotification({
    required String partName,
    String? note,
  }) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'switch_events',
      'Anteilwechsel',
      channelDescription: 'Benachrichtigungen bei Anteilwechseln',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Anteilwechsel',
      '$partName ist jetzt vorne',
      details,
    );
  }

  static Future<void> showSyncNotification(String message) async {
    await init();

    const androidDetails = AndroidNotificationDetails(
      'sync_events',
      'Sync',
      channelDescription: 'Sync-Benachrichtigungen',
      importance: Importance.low,
      priority: Priority.low,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(1, 'Refugium Sync', message, details);
  }
}
