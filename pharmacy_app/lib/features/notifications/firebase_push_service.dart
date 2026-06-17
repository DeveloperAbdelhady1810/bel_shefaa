import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'push_service.dart';

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {}

class FirebasePushService implements PushService {
  static const _channelId   = 'high_importance_channel';
  static const _channelName = 'Quota Pharmacy Notifications';
  static final _fln         = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    if (Platform.isAndroid) {
      await _fln
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
            const AndroidNotificationChannel(
              _channelId,
              _channelName,
              importance: Importance.high,
            ),
          );
    }

    await _fln.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true, provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true,
      );
      FirebaseMessaging.onMessage.listen(_showLocal);
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> registerToken(String token) async {}

  static void _showLocal(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    _fln.show(
      n.hashCode,
      n.title,
      n.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true,
        ),
      ),
    );
  }
}
