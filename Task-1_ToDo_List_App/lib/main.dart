import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'models/task.dart';
import 'models/category.dart';
import 'models/notification_item.dart';
import 'screens/welcome_screen.dart';
import 'screens/name_input_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/task_form_screen.dart';
import 'theme/app_theme.dart';
import 'services/notification_checker.dart';
import 'services/local_notification_service.dart';

// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('\n🔔 ========== BACKGROUND HANDLER STARTED ========== 🔔');
  print('📩 Message: ${message.notification?.title}');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('✅ Firebase initialized in background');

  // Initialize Hive for background - use initFlutter to match foreground
  await Hive.initFlutter();
  print('✅ Hive.initFlutter() called in background');

  // Register all adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskAdapter());
    print('✅ TaskAdapter registered');
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CategoryAdapter());
    print('✅ CategoryAdapter registered');
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(NotificationItemAdapter());
    print('✅ NotificationItemAdapter registered');
  }

  // Open notifications box
  print('🔓 Opening notifications box in background...');
  final notificationBox = await Hive.openBox<NotificationItem>('notifications');
  print('✅ Notifications box opened successfully');

  // Save notification to Hive
  try {
    print('📦 [BACKGROUND] Box path: ${notificationBox.path}');
    print('🔓 [BACKGROUND] Box is open: ${notificationBox.isOpen}');
    print(
      '📊 [BACKGROUND] Current box length BEFORE save: ${notificationBox.length}',
    );

    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'Task Reminder',
      body: message.notification?.body ?? '',
      receivedAt: DateTime.now(),
      taskId: message.data['taskId'] ?? '',
    );

    final key = await notificationBox.add(notification);
    print('💾 Notification added with key: $key');

    await notificationBox.flush(); // Force write to disk
    print('💾 Box flushed to disk');

    print('✅ [BACKGROUND] Notification saved to Hive with key: $key');
    print(
      '📊 [BACKGROUND] Total notifications AFTER save: ${notificationBox.length}',
    );
    print('🔍 [BACKGROUND] Can retrieve: ${notificationBox.get(key) != null}');

    // Verify by listing all notifications
    print('📋 All notifications in box:');
    for (var i = 0; i < notificationBox.length; i++) {
      final n = notificationBox.getAt(i);
      print('  [$i] ${n?.title} - ${n?.body}');
    }

    // Close the box to release file lock
    await notificationBox.close();
    print('🔒 [BACKGROUND] Box closed after save');
  } catch (e, stackTrace) {
    print('❌ [BACKGROUND] Error saving notification: $e');
    print('❌ [BACKGROUND] Stack trace: $stackTrace');
  }

  // Initialize local notifications for background
  await LocalNotificationService.initialize(requestPermission: false);
  print('✅ LocalNotificationService initialized in background');

  // Show notification when app is in background
  await LocalNotificationService.showNotification(message);
  print('✅ Notification shown via LocalNotificationService');

  print('🔔 ========== BACKGROUND HANDLER COMPLETED ========== 🔔\n');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Subscribe to notification topic
  await FirebaseMessaging.instance.subscribeToTopic('ToDos');
  print('✅ Subscribed to ToDos topic');

  // Initialize local notifications
  await LocalNotificationService.initialize();
  print('✅ Local notifications initialized');

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters (check if already registered to avoid corruption)
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(CategoryAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(NotificationItemAdapter());
  }

  // Open boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Category>('categories');
  await Hive.openBox('settings');
  await Hive.openBox<NotificationItem>('notifications');
  print('📂 [MAIN] All boxes opened including notifications');

  // Start automatic notification checking
  NotificationChecker.startChecking();

  // Handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('📩 Received foreground notification!');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');

    // Save notification to Hive
    try {
      // Use the already open box - don't close it while UI is watching
      final notificationBox = Hive.box<NotificationItem>('notifications');

      print('📂 [FOREGROUND] Box path: ${notificationBox.path}');

      final notification = NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ?? 'Task Reminder',
        body: message.notification?.body ?? '',
        receivedAt: DateTime.now(),
        taskId: message.data['taskId'] ?? '',
      );

      final key = await notificationBox.add(notification);
      await notificationBox.flush();

      print('✅ [FOREGROUND] Notification saved with key: $key');
    } catch (e, stackTrace) {
      print('❌ [FOREGROUND] Error saving notification: $e');
      print('❌ [FOREGROUND] Stack: $stackTrace');
    }

    // Display notification even when app is in foreground
    LocalNotificationService.showNotification(message);
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasky',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialRouteHandler(),
        '/welcome': (context) => const WelcomeScreen(),
        '/name-input': (context) => const NameInputScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/task-form') {
          final task = settings.arguments as Task?;
          return MaterialPageRoute(
            builder: (context) => TaskFormScreen(task: task),
          );
        }
        return null;
      },
    );
  }
}

class InitialRouteHandler extends StatelessWidget {
  const InitialRouteHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final hasVisited =
              snapshot.data?.get('hasVisited', defaultValue: false) ?? false;

          if (hasVisited) {
            // User has visited before, go to dashboard
            Future.microtask(
              () => Navigator.pushReplacementNamed(context, '/dashboard'),
            );
          } else {
            // First time user, show welcome screen
            snapshot.data?.put('hasVisited', true);
            Future.microtask(
              () => Navigator.pushReplacementNamed(context, '/welcome'),
            );
          }
        }

        // Loading screen
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFF7C4DFF)),
          ),
        );
      },
    );
  }
}
