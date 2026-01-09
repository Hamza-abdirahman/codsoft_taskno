# Cloud Functions Setup for Automatic Task Notifications

This guide will help you set up Firebase Cloud Functions to send automatic push notifications when tasks are due.

## Prerequisites

1. Node.js installed (v18 or later)
2. Firebase CLI installed
3. Firebase project already configured (you have this done)

## Setup Steps

### 1. Install Firebase CLI (if not already installed)

```bash
npm install -g firebase-tools
```

### 2. Login to Firebase

```bash
firebase login
```

### 3. Initialize Firebase in your project directory

```bash
cd c:\flutter_projects_udemy\to_do_list_app
firebase init functions
```

When prompted:
- Select your existing Firebase project: **to-do-list-app-98e44**
- Choose language: **JavaScript**
- Use ESLint: **No**
- Install dependencies: **Yes**

### 4. The functions folder is already created with the necessary files

The following files are ready:
- `functions/index.js` - Contains the cloud function code
- `functions/package.json` - Node.js dependencies

### 5. Install dependencies

```bash
cd functions
npm install
```

### 6. Deploy Cloud Functions

```bash
firebase deploy --only functions
```

## How It Works

### Cloud Function: `sendScheduledNotifications`

- Runs **every 1 minute** (you can change this in index.js)
- Checks Firestore for tasks with `notificationTime` within the last minute
- Sends FCM notification to the **ToDos** topic
- Notification is sent **5 minutes before** the task due date (configurable in firestore_service.dart)
- Automatically deletes the scheduled task after sending notification

### Cloud Function: `onTaskCreated`

- Triggers when a new task is added to Firestore
- Sends immediate confirmation: "✅ Task Scheduled"

## Flutter App Integration

The app is already configured to:

1. **Save tasks to Firestore** when created/updated (task_form_screen.dart)
2. **Store device FCM token** in Firestore (welcome_screen.dart)
3. **Subscribe to 'ToDos' topic** for receiving notifications
4. **Sync task data** including notification time (5 min before due date)

## Customization

### Change notification timing (firestore_service.dart)

```dart
// Currently set to 5 minutes before
DateTime notificationTime = task.dueDate.subtract(const Duration(minutes: 5));

// Change to 15 minutes:
DateTime notificationTime = task.dueDate.subtract(const Duration(minutes: 15));

// Change to 1 hour:
DateTime notificationTime = task.dueDate.subtract(const Duration(hours: 1));
```

### Change function schedule (functions/index.js)

```javascript
// Currently runs every 1 minute
.schedule("every 1 minutes")

// Change to every 5 minutes:
.schedule("every 5 minutes")

// Change to every hour:
.schedule("every 60 minutes")
```

## Testing

1. Create a task in your app with a due date/time in the near future
2. Wait for the notification time (5 minutes before due date)
3. You should receive a push notification: "⏰ Task Reminder"

## Firestore Structure

Tasks are stored in: `scheduled_tasks/{taskId}`

```json
{
  "taskId": "uuid",
  "title": "Task title",
  "description": "Task description",
  "dueDate": "2025-12-23T15:30:00.000",
  "notificationTime": "2025-12-23T15:25:00.000",
  "deviceToken": "FCM-TOKEN",
  "topic": "ToDos",
  "priority": "high",
  "isCompleted": false,
  "createdAt": "2025-12-23T10:00:00.000",
  "categoryId": "category-uuid"
}
```

## Troubleshooting

### Functions not deploying
```bash
# Check Firebase project
firebase projects:list

# Make sure you're using the right project
firebase use to-do-list-app-98e44
```

### Notifications not sending
1. Check Firebase Console → Functions → Logs
2. Verify tasks are being added to Firestore: Firebase Console → Firestore Database
3. Check that device is subscribed to 'ToDos' topic

### Enable Firestore
If Firestore is not enabled:
1. Go to Firebase Console
2. Select your project
3. Go to Firestore Database
4. Click "Create database"
5. Choose production mode
6. Select a location

## Cost

- Cloud Functions: Free tier includes 2M invocations/month
- Firestore: Free tier includes 50K reads, 20K writes, 20K deletes per day
- FCM: Completely free

For this app's usage, you should stay well within the free tier limits.

## Next Steps

After deployment, run:

```bash
flutter pub get
flutter run
```

Create a task and test the notifications! 🎉
