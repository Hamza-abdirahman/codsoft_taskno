import 'dart:async';
import 'package:http/http.dart' as http;

class NotificationChecker {
  static Timer? _timer;

  // Replace with your actual function URL from Firebase Console
  static const String _functionUrl =
      'https://us-central1-to-do-list-app-98e44.cloudfunctions.net/checkScheduledNotifications';

  // Start checking for notifications every 10 seconds
  static void startChecking() {
    // Check immediately
    _checkNotifications();

    // Then check every 10 seconds for faster notification delivery
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkNotifications();
    });
  }

  // Stop checking
  static void stopChecking() {
    _timer?.cancel();
    _timer = null;
  }

  // Call the Cloud Function to check for notifications
  static Future<void> _checkNotifications() async {
    try {
      final response = await http.get(Uri.parse(_functionUrl));
      print('Notification check response: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('✅ Notification check successful: ${response.body}');
      }
    } catch (e) {
      print('Error checking notifications: $e');
    }
  }
}
