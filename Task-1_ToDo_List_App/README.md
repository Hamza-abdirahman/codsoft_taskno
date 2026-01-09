<<<<<<< HEAD
# 📝 To-Do List App

A comprehensive and feature-rich task management application built with Flutter and Hive for local storage. This app helps you organize your daily tasks, track progress, and stay productive with an intuitive and beautiful interface.

## ✨ Features

### 🎯 Task Management
- **Create Tasks**: Add tasks with title, description, due date, and time
- **Categories**: Organize tasks with custom categories (Work, Personal, Shopping, etc.)
- **Task Status**: Mark tasks as complete/incomplete
- **Search & Filter**: Search tasks by title/description and filter by status or category
- **Priority Management**: Visual indicators for task importance
- **Delete Tasks**: Remove unwanted tasks with confirmation dialog

### 📊 Dashboard & Analytics
- **Daily Goal**: Set and track daily task completion goals
- **Progress Tracking**: Real-time progress percentage for today's tasks
- **Overdue Alerts**: Visual alerts for overdue tasks
- **Completion Stats**: Track completed tasks for the day
- **Category Cards**: Visual overview of tasks grouped by category

### 📅 Schedule View
- **Calendar Integration**: Interactive calendar with task visualization
- **Monthly View**: See all tasks scheduled for the month
- **Task Details**: View task information directly from calendar
- **Date Navigation**: Easy navigation between months and years

### 🔔 Notifications
- **Task Reminders**: Automatic notifications for scheduled tasks
- **Notification Drawer**: Centralized notification management
- **Badge Indicators**: Visual badge showing unread notification count
- **Swipe to Dismiss**: Easy notification management

### 👤 Profile & Settings
- **User Profile**: Customizable profile with name and photo
- **Profile Picture**: Add profile image from camera or gallery
- **Daily Goal Setting**: Configure your daily task completion target
- **Category Management**: Create, edit, and delete custom categories
- **Custom Category Icons**: Choose from emoji icons for categories
- **Color Coding**: Assign unique colors to categories

### 🎨 UI/UX Features
- **Beautiful Gradients**: Modern gradient design throughout the app
- **Smooth Animations**: Fluid transitions and interactions
- **Responsive Layout**: Adapts to different screen sizes
- **Bottom Navigation**: Easy switching between Dashboard, Schedule, and Profile
- **Search Bar**: Quick task search functionality
- **Empty States**: Helpful messages when no data is available

## 🛠️ Tech Stack

### Core Technologies
- **Flutter**: Cross-platform mobile framework
- **Dart**: Programming language
- **Hive**: Fast, NoSQL local database
- **Provider Pattern**: State management

### Key Packages
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Hive Flutter integration
- `intl: ^0.19.0` - Internationalization and date formatting
- `table_calendar: ^3.1.2` - Calendar widget
- `image_picker: ^1.1.2` - Image selection from camera/gallery
- `path_provider: ^2.1.1` - File system paths
- `flutter_local_notifications: ^18.0.1` - Local notifications
- `firebase_core: ^4.3.0` - Firebase core functionality
- `firebase_messaging: ^16.1.0` - Push notifications
- `cloud_firestore: ^6.1.1` - Cloud database
- `google_fonts: ^6.2.1` - Custom fonts
- `uuid: ^4.5.1` - Unique ID generation

## 📱 Screenshots

### Dashboard
- Statistics cards showing Daily Goal, Progress, Overdue, and Completed tasks
- Category cards with task counts
- Filterable task list with search

### Schedule View
- Interactive calendar with task markers
- Monthly task overview
- Easy date navigation

### Profile View
- User profile with customizable avatar
- Daily goal configuration
- Category management
- App information

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.7.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Visual Studio Code (recommended)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd to_do_list_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

**Android**
```bash
flutter build apk --release
```

**iOS**
```bash
flutter build ios --release
```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── task.dart                      # Task model with Hive adapter
│   ├── category.dart                  # Category model
│   └── notification_item.dart         # Notification model
├── screens/                           # Main screens
│   └── dashboard_screen.dart          # Main dashboard with navigation
├── widgets/                           # Reusable widgets
│   ├── task_form_dialog.dart          # Task creation/edit dialog
│   ├── category_management_dialog.dart # Category management
│   └── dashboard/                     # Dashboard-specific widgets
│       ├── statistics_section.dart    # Stats cards section
│       ├── metric_card.dart           # Individual metric card
│       ├── task_cards.dart            # Task card widget
│       ├── schedule_view.dart         # Calendar view
│       ├── profile_view.dart          # Profile screen
│       └── dialogs.dart               # Reusable dialogs
└── services/                          # Business logic services
    └── notification_service.dart      # Notification handling
```

## 💾 Data Models

### Task Model
```dart
{
  id: String (UUID)
  title: String
  description: String
  dueDate: DateTime
  isCompleted: bool
  categoryId: String (optional)
  createdAt: DateTime
}
```

### Category Model
```dart
{
  id: String (UUID)
  name: String
  icon: String (emoji)
  color: String (hex)
  createdAt: DateTime
}
```

### Notification Model
```dart
{
  id: String
  title: String
  body: String
  receivedAt: DateTime
  isRead: bool
}
```

## 🎯 Key Features Implementation

### Daily Goal System
- Set custom daily task goals in Profile
- Real-time progress tracking
- Visual feedback when goal is achieved
- Stored in Hive local storage

### Category System
- Create unlimited custom categories
- Assign emoji icons and colors
- Filter tasks by category
- Visual category cards on dashboard

### Notification System
- Automatic task reminders
- Background notification handling
- Notification drawer with badge
- Mark as read functionality

### Calendar Integration
- Visual task markers on calendar
- Multi-select task viewing
- Month/year navigation
- Today's tasks highlight

## 🔧 Configuration

### Hive Boxes
- `tasks` - Stores all tasks
- `categories` - Stores custom categories
- `notifications` - Stores notification items
- `settings` - Stores user preferences (name, profile image, daily goal)

### Default Settings
- Daily Goal: 5 tasks
- Default Categories: None (user creates them)
- Theme: Purple gradient (#7C4DFF primary)

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Developer

Built with ❤️ using Flutter

## 🐛 Known Issues

- None at the moment

## 🔮 Future Enhancements

- [ ] Task priority levels (High, Medium, Low)
- [ ] Recurring tasks
- [ ] Task notes and attachments
- [ ] Dark mode support
- [ ] Cloud sync with Firebase
- [ ] Task sharing and collaboration
- [ ] Weekly/Monthly reports
- [ ] Task templates
- [ ] Voice input for tasks
- [ ] Widget support

## 📞 Support

For support, please open an issue in the repository.

---

**Version**: 1.0.0  
**Last Updated**: January 2026  
**Platform**: iOS, Android  
**Framework**: Flutter 3.7.2+
=======
# To-do-list-app
>>>>>>> 0ad6b6a1eac8c90e3357d248a0bb2fc0fb639995
