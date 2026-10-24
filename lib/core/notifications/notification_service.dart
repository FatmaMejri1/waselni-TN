import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/notifications/data/notification_database.dart';
import '../../features/notifications/domain/notification_model.dart';
import '../../firebase_options.dart';
import '../constants/routes.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Background message received: ${message.messageId}');

  // Save the notification received in the background to SQLite.
  final notification = message.notification;
  final title = notification?.title ?? message.data['title'] as String?;
  final body = notification?.body ?? message.data['body'] as String?;

  if ((title == null || title.isNotEmpty) &&
      (body == null || body.isNotEmpty) &&
      (title != null || body != null)) {
    try {
      await NotificationDatabase.instance.save(
        NotificationModel(
          id: message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}',
          title: title ?? 'Waselni',
          body: body ?? '',
          receivedAt: DateTime.now(),
          targetScreen: _targetScreen(message.data),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Failed to save background notification: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

String _targetScreen(Map<String, dynamic> data) {
  final screen = data['screen'];

  if (screen == Routes.home) {
    return Routes.home;
  }

  return Routes.home;
}

class NotificationService {
  NotificationService._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'waselni_updates',
    'Waselni updates',
    description: 'Notifications about transport updates and reports.',
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: _handleLocalNotificationTap,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _requestPermission();

    try {
      final token = await _messaging.getToken();
      debugPrint('FCM registration token: $token');
    } catch (error, stackTrace) {
      debugPrint('FCM token error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleRemoteNotificationTap(initialMessage);
    }
  }

  static Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    final savedNotification = NotificationModel(
      id: message.messageId ?? '${DateTime.now().microsecondsSinceEpoch}',
      title: title ?? 'Waselni',
      body: body ?? '',
      receivedAt: DateTime.now(),
      targetScreen: _targetScreen(message.data),
    );

    try {
      await NotificationDatabase.instance.save(savedNotification);
    } catch (error, stackTrace) {
      debugPrint('Failed to save notification: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    await _localNotifications.show(
      id: savedNotification.id.hashCode,
      title: savedNotification.title,
      body: savedNotification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static void _handleRemoteNotificationTap(RemoteMessage message) {
    _navigateFromData(message.data);
  }

  static void _handleLocalNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final decoded = jsonDecode(payload);

      if (decoded is Map<String, dynamic>) {
        _navigateFromData(decoded);
      }
    } catch (error) {
      debugPrint('Invalid notification payload: $error');
    }
  }

  static void _navigateFromData(Map<String, dynamic> data) {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      debugPrint('Navigator is not ready yet.');
      return;
    }

    navigator.pushNamed(_targetScreen(data));
  }
}
