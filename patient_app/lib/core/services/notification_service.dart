import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Providers ────────────────────────────────────────────────────────────────

/// Route string set when a notification tap should trigger navigation.
final notificationPendingRouteProvider = StateProvider<String?>((ref) => null);

// ─── Background handler (top-level required by Firebase) ─────────────────────

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {}

// ─── Service ──────────────────────────────────────────────────────────────────

class NotificationService {
  static const _channelId   = 'high_importance_channel';
  static const _channelName = 'Quota Notifications';
  static final  _fln        = FlutterLocalNotificationsPlugin();

  static ProviderContainer? _container;

  /// Call once in main() after Firebase.initializeApp().
  static Future<void> init({ProviderContainer? container}) async {
    _container = container;

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

    FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
  }

  /// Call after the first frame to handle the terminated-app case.
  static Future<void> checkInitialMessage() async {
    final msg = await FirebaseMessaging.instance.getInitialMessage();
    if (msg != null) _handleTap(msg);
  }

  /// Call after login to register the device token with the backend.
  /// Pass the authenticated [dio] instance so the request carries the Bearer token.
  static Future<void> syncToken(dynamic dio) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await dio.put('/patient/fcm-token', data: {'fcm_token': token});
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
        try {
          await dio.put('/patient/fcm-token', data: {'fcm_token': t});
        } catch (_) {}
      });
    } catch (_) {}
  }

  // ─── Internal ───────────────────────────────────────────────────────────────

  static void _handleTap(RemoteMessage message) {
    final action   = message.data['action']    as String?;
    final actionId = message.data['action_id'] as String?;
    final id       = actionId != null ? int.tryParse(actionId) : null;

    switch (action) {
      case 'order_accepted':
      case 'order_update':
        _container?.read(notificationPendingRouteProvider.notifier).state =
            id != null ? '/tracking/$id' : '/orders-history';
      default:
        break;
    }
  }

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
