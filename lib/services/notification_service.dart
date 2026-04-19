import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fair_share/l10n/app_localizations.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> showPersistentTimerNotification({
    required BuildContext context,
    required int remainingSeconds,
  }) async {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    final loc = AppLocalizations.of(context)!;
    final timeString = remainingSeconds == 0
        ? loc.notificationPaused
        : h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';

    const androidDetails = AndroidNotificationDetails(
      'timer_channel',
      'Timer',
      channelDescription: 'Live countdown timer',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      showWhen: false,
    );

    await _plugin.show(
      0,
      loc.notificationTimerTitle,
      loc.notificationTimerRemaining(timeString),
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> showAlarmNotification(
    BuildContext context,
    String messageKey,
  ) async {
    final loc = AppLocalizations.of(context)!;

    final message = messageKey == 'oneMinute'
        ? loc.notificationOneMinute
        : loc.notificationTimeUp;

    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Timer Alerts',
      channelDescription: 'Alerts for timer events',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      loc.notificationTimerTitle,
      message,
      const NotificationDetails(android: androidDetails),
    );
  }
}
