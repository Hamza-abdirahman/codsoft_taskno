const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Listen to new tasks and schedule notification
exports.onTaskCreated = functions.firestore
    .document("scheduled_tasks/{taskId}")
    .onCreate(async (snap, context) => {
      const task = snap.data();
      console.log(`Task created: ${task.title} - notification will be sent at scheduled time`);
      // Notification will be sent by scheduledNotificationCheck function at the scheduled time
    });

// Scheduled function that runs every minute to check for due notifications
exports.scheduledNotificationCheck = functions.pubsub
    .schedule("every 1 minutes")
    .timeZone("UTC")
    .onRun(async (context) => {
      console.log("🔔 Scheduled notification check triggered");
      await checkAndSendNotifications();
      return null;
    });

// Shared function to check and send notifications
async function checkAndSendNotifications() {
  const now = new Date();
  const db = admin.firestore();

  console.log(`🕐 Current time: ${now.toISOString()}`);

  try {
    // Get all scheduled tasks that are due for notification
    const tasksSnapshot = await db
        .collection("scheduled_tasks")
        .where("isCompleted", "==", false)
        .get();

    console.log(`📋 Found ${tasksSnapshot.size} scheduled tasks`);

    const notificationPromises = [];
    let sentCount = 0;

    tasksSnapshot.forEach((doc) => {
      const task = doc.data();
      
      // Handle both Timestamp and string formats for backward compatibility
      let notificationTime;
      if (task.notificationTime && typeof task.notificationTime.toDate === 'function') {
        // It's a Firestore Timestamp
        notificationTime = task.notificationTime.toDate();
      } else if (typeof task.notificationTime === 'string') {
        // It's a string, parse it
        notificationTime = new Date(task.notificationTime);
      } else {
        console.log(`⚠️ Skipping task ${task.title} - invalid notificationTime format`);
        return;
      }

      console.log(`📝 Task: ${task.title}`);
      console.log(`   Notification time: ${notificationTime.toISOString()}`);
      console.log(`   Current time: ${now.toISOString()}`);
      
      // Check if it's time to send notification (within the last 5 minutes)
      const timeDiff = now - notificationTime;
      console.log(`   Time diff: ${timeDiff}ms (${Math.floor(timeDiff / 1000)}s)`);
      
      if (timeDiff < 0) {
        console.log(`   ⏳ Notification scheduled for future (in ${Math.abs(Math.floor(timeDiff / 1000))}s)`);
      }
      
      // Only send if notification time has passed AND it's within the last 5 minutes
      if (timeDiff >= 0 && timeDiff <= 300000) {
        // Within 5 minute window AND notification time has passed
        console.log(`✅ Sending notification for task: ${task.title}`);

        // Send to topic
        const message = {
          notification: {
            title: "⏰ Task Reminder",
            body: `Time to: ${task.title}`,
          },
          data: {
            taskId: task.taskId,
            priority: task.priority || "medium",
            dueDate: task.dueDate && typeof task.dueDate.toDate === 'function' 
              ? task.dueDate.toDate().toISOString() 
              : task.dueDate,
          },
          topic: "ToDos",
        };

        sentCount++;
        notificationPromises.push(
            admin.messaging().send(message).then((response) => {
              console.log("Successfully sent message:", response);
              // Delete the task after sending notification
              return db.collection("scheduled_tasks").doc(doc.id).delete();
            }).catch((error) => {
              console.error("Error sending message:", error);
            }),
        );
      }
    });

    await Promise.all(notificationPromises);
    console.log(`Notification check complete. Sent ${sentCount} notifications.`);
    
    return sentCount;
  } catch (error) {
    console.error("Error in notification check:", error);
    throw error;
  }
}

// HTTP function to check and send notifications (for manual triggering)
exports.checkScheduledNotifications = functions.https.onRequest(async (req, res) => {
  try {
    const sentCount = await checkAndSendNotifications();
    res.status(200).send({success: true, sentCount: sentCount});
  } catch (error) {
    res.status(500).send({success: false, error: error.message});
  }
});

