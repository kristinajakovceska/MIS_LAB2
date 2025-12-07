import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _fln = FlutterLocalNotificationsPlugin();

  static const String channelId = 'recipes_daily_channel';
  static const String channelName = 'Daily Recipes';
  static const String channelDesc = 'Daily reminder for random recipe';

  Future<void> init({
    required void Function(NotificationResponse) onTap,
  }) async {
    // TZ init
    tz.initializeTimeZones();
    // Иницијализација на плагин
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initSettings = InitializationSettings(android: androidInit);

    await _fln.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Канал
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.high,
      playSound: true,
    );

    await _fln
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Android 13+ runtime permission
    await _fln
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> showNow({
    required String title,
    required String body,
    String? payload,
  }) async {
    const android = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );

    await _fln.show(
      1001,
      title,
      body,
      const NotificationDetails(android: android),
      payload: payload,
    );
  }

  /// Закажи дневна нотификација во локално време.
  Future<void> scheduleDailyAt({
    required TimeOfDay time,
    String title = 'Daily recipe',
    String body = 'Tap to see a random recipe of the day',
    String payload = 'random',
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var sched = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (sched.isBefore(now)) {
      sched = sched.add(const Duration(days: 1));
    }

    const android = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );

    await _fln.zonedSchedule(
      2001, // notification id
      title,
      body,
      sched,
      const NotificationDetails(android: android),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // секој ден исто време
      payload: payload,
    );
  }

  Future<void> cancelDaily() async {
    await _fln.cancel(2001);
  }
}

// Background tap handler (Android)
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Ништо посебно за background во овој проект.
}
