import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Request notification permission
  Future<bool> requestPermission() async {
    try {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
        return true;
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
        return true;
      } else {
        debugPrint('User declined or has not accepted permission');
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return false;
    }
  }

  // Get device FCM token (address)
  Future<String?> getDeviceToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint('Device FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting device token: $e');
      return null;
    }
  }

  // Initialize notification service
  Future<void> initialize() async {
    // Request permission
    bool permissionGranted = await requestPermission();

    if (permissionGranted) {
      // Get device token
      String? token = await getDeviceToken();

      if (token != null) {
        // You can save this token to your database or use it for sending notifications
        debugPrint('Notification service initialized with token: $token');
      }
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      // Update token in your database
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification}',
        );
        // You can show a local notification here
      }
    });

    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      debugPrint('Message data: ${message.data}');
      // Navigate to specific screen based on notification data
    });
  }

  // Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    try {
      NotificationSettings settings =
          await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      debugPrint('Error checking notification status: $e');
      return false;
    }
  }
}
