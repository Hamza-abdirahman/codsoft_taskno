# 🚀 Quick Start Guide

## Run the App Right Now

```bash
flutter run
```

That's it! The app is ready to use.

## What You'll See

### First Launch
1. **Welcome Screen** with "Tasky" branding
2. **Name Input** to personalize your experience
3. **Dashboard** with empty state

### After Adding Tasks
- See your tasks organized beautifully
- Statistics cards showing Total/Active/Done counts
- Search and filter capabilities
- Smooth animations and interactions

## Quick Test Flow

1. **Launch App** → See Welcome Screen
2. **Tap "Get Started"** → Enter your name (or skip)
3. **Tap FAB (+)** → Create your first task:
   - Title: "Buy groceries"
   - Description: "Milk, eggs, bread"
   - Due Date: Tomorrow
   - Priority: High
4. **Create Task** → See it in the dashboard
5. **Tap the circular checkbox** → Mark as complete
6. **Tap "Completed" tab** → See your completed task
7. **Try the search** → Find tasks quickly
8. **Tap task card** → Edit task details
9. **Tap delete icon** → Remove a task

## Available Commands

```bash
# Run the app
flutter run

# Run on specific device
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d [device-id]     # Specific device

# Build release version
flutter build apk              # Android
flutter build ios              # iOS
flutter build windows          # Windows

# Clean and rebuild (if needed)
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run

# Format code
dart format lib/

# Analyze code
flutter analyze
```

## Hot Reload Tips

While the app is running:
- Press `r` → Hot reload (apply small changes)
- Press `R` → Hot restart (full restart)
- Press `q` → Quit

## Testing the App

### Create Multiple Tasks
Try creating tasks with different:
- Priorities (Low/Medium/High)
- Due dates (today, tomorrow, next week)
- With and without descriptions

### Test Search & Filter
1. Create 5+ tasks
2. Mark some as completed
3. Use search to find specific tasks
4. Toggle between All/Active/Completed tabs
5. Combine search with filters

### Test Persistence
1. Create several tasks
2. Close the app completely
3. Reopen → All tasks should be there!

## Customization Ideas

### Change App Name
Edit [lib/screens/welcome_screen.dart](lib/screens/welcome_screen.dart):
```dart
const Text('Tasky') → const Text('Your App Name')
```

### Change Primary Color
Edit [lib/theme/app_theme.dart](lib/theme/app_theme.dart):
```dart
static const Color primaryPurple = Color(0xFF7C4DFF);
// Change to any color you like!
```

### Add New Priority Levels
Edit [lib/screens/task_form_screen.dart](lib/screens/task_form_screen.dart) and [lib/models/task.dart](lib/models/task.dart)

## File Structure Reference

```
lib/
├── main.dart                    ← App initialization, routing
├── models/
│   ├── task.dart               ← Task data model
│   └── task.g.dart             ← Generated Hive adapter
├── screens/
│   ├── welcome_screen.dart     ← Onboarding
│   ├── name_input_screen.dart  ← User name collection
│   ├── dashboard_screen.dart   ← Main screen (home)
│   └── task_form_screen.dart   ← Add/Edit tasks
└── theme/
    └── app_theme.dart          ← Colors, fonts, styling
```

## Troubleshooting

### App won't build?
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Tasks not persisting?
- Hive should be working automatically
- Check that Hive initialization completed in main.dart

### Font not loading?
- Internet required for first Google Fonts download
- Fonts are cached after first load

### Colors look different?
- Check your device's dark mode settings
- App currently uses light theme only

## Next Steps

### Enhance the App
- Add categories/tags
- Add notifications for due dates
- Add dark mode support
- Add task sorting options
- Add data export/import
- Add task notes/attachments
- Add recurring tasks

### Learn More
- [Flutter Documentation](https://flutter.dev/docs)
- [Hive Database](https://docs.hivedb.dev/)
- [Material Design 3](https://m3.material.io/)
- [Google Fonts](https://fonts.google.com/)

---

**Enjoy building with Flutter! 🎉**
