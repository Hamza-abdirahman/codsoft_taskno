import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  // Singleton pattern
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user's device token (you'll need to pass this)
  String? _deviceToken;

  void setDeviceToken(String token) {
    _deviceToken = token;
  }

  // Add or update task in Firestore for cloud notifications
  Future<void> syncTask(Task task) async {
    print('========================================');
    print('🔄 ATTEMPTING TO SYNC TASK TO FIRESTORE');
    print('Task ID: ${task.id}');
    print('Task Title: ${task.title}');
    print('Due Date: ${task.dueDate}');
    print('Device Token: $_deviceToken');

    try {
      // Calculate notification time (2 minutes before due date)
      DateTime notificationTime = task.dueDate.subtract(
        const Duration(minutes: 2),
      );

      print('Notification Time: $notificationTime');
      print('Current Time: ${DateTime.now()}');
      print('Is Future: ${notificationTime.isAfter(DateTime.now())}');
      print('Is Completed: ${task.isCompleted}');

      // Only schedule if notification time is in the future
      if (notificationTime.isAfter(DateTime.now()) && !task.isCompleted) {
        print('✅ Conditions met - syncing to Firestore...');
        await _firestore.collection('scheduled_tasks').doc(task.id).set({
          'taskId': task.id,
          'title': task.title,
          'description': task.description,
          'dueDate': Timestamp.fromDate(task.dueDate),
          'notificationTime': Timestamp.fromDate(notificationTime),
          'deviceToken': _deviceToken,
          'topic': 'ToDos', // Send to topic
          'priority': task.priority,
          'isCompleted': task.isCompleted,
          'createdAt': Timestamp.fromDate(task.createdAt),
          'categoryId': task.categoryId,
        });
        print('✅✅✅ TASK SYNCED SUCCESSFULLY TO FIRESTORE!');
        print('========================================');
      } else {
        print(
          '⚠️ Task NOT synced - notification time is in the past or task is completed',
        );
        print('========================================');
      }
    } catch (e) {
      print('❌ ERROR syncing task to Firestore: $e');
      print('========================================');
    }
  }

  // Delete task from Firestore when completed or deleted
  Future<void> deleteScheduledTask(String taskId) async {
    try {
      await _firestore.collection('scheduled_tasks').doc(taskId).delete();
    } catch (e) {
      print('Error deleting scheduled task: $e');
    }
  }

  // Update task completion status
  Future<void> markTaskCompleted(String taskId) async {
    try {
      await _firestore.collection('scheduled_tasks').doc(taskId).update({
        'isCompleted': true,
      });
      // Optionally delete it
      await deleteScheduledTask(taskId);
    } catch (e) {
      print('Error marking task completed: $e');
    }
  }
}
