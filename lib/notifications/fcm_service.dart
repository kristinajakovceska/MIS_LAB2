import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

/// Background message handler. мора да е top-level функција.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Во оваа демо верзија само логираме. За производствено, иницијализирај Firebase тука.
  log('BG FCM: ${message.messageId}');
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Барање дозволи (Android 13+ ќе ги користи и системските за нотификации)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Поврзи background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Token за тестирање push од Firebase Console
    final token = await _messaging.getToken();
    log('FCM token: $token');

    // Foreground пораки -> ќе прикажеме локална нотификација
    FirebaseMessaging.onMessage.listen((RemoteMessage m) {
      final notif = m.notification;
      final title = notif?.title ?? 'New recipe';
      final body = notif?.body ?? 'Tap to see random recipe';
      NotificationService.instance.showNow(
        title: title,
        body: body,
        payload: 'random',
      );
    });

    // Кога корисник ќе тапне на push и ќе отвори апликација
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage m) async {
      // Payload „random“ ќе го обработиме во main преку onTap колбекот.
      NotificationService.instance.showNow(
        title: m.notification?.title ?? 'Daily recipe',
        body: m.notification?.body ?? 'Tap to see random recipe',
        payload: 'random',
      );
    });
  }
}
