# Tasky - Modern To-Do List App

A beautiful, polished Flutter To-Do List application with a modern dashboard aesthetic and comprehensive task management features.

## ✨ Features

### 📱 Four Main Screens
1. **Welcome Screen** - Friendly onboarding with app introduction
2. **Name Input Screen** - Personalized user experience
3. **Dashboard Screen** - Complete task management hub
4. **Task Form Screen** - Add/Edit tasks with full details

### 🎯 Core Functionality
- ✅ **Create, Edit, and Delete Tasks**
- 📝 Task details include:
  - Title (required)
  - Description (optional)
  - Priority level (Low/Medium/High with color coding)
  - Due date and time
  - Completion status
- 🔍 **Search** tasks by title or description
- 🏷️ **Filter** tasks by:
  - All Tasks
  - Active Tasks
  - Completed Tasks
- 📊 **Statistics Dashboard**:
  - Total tasks
  - Active tasks
  - Completed tasks
- 💾 **Offline Storage** with Hive (local persistence)
- 🎨 **Modern UI** with smooth animations

## 🎨 Design System

### Color Palette
- **Primary Purple**: `#7C4DFF` - Buttons, FAB, active states
- **Background**: `#F9F5FF` with gradient
- **Card Background**: `#FFFFFF`
- **Text Primary**: `#111827`
- **Text Secondary**: `#6B7280`
- **Text Muted**: `#9CA3AF`

### Priority Colors
- **High**: `#EF4444` (Red)
- **Medium**: `#F59E0B` (Amber)
- **Low**: `#22C55E` (Green)

### Typography
- **Font Family**: Inter (via Google Fonts)
- Clean, modern, and highly readable

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: StatefulWidget with ValueListenableBuilder
- **Local Storage**: Hive + Hive Flutter
- **Fonts**: Google Fonts (Inter)
- **Date Formatting**: intl package
- **Unique IDs**: uuid package

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.2.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  uuid: ^4.5.1
  intl: ^0.19.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.13
  flutter_lints: ^5.0.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone or navigate to the project directory**
   ```bash
   cd to_do_list_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (if needed)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point, Hive initialization, routing
├── models/
│   ├── task.dart               # Task model with Hive annotations
│   └── task.g.dart             # Generated Hive adapter
├── screens/
│   ├── welcome_screen.dart     # Onboarding screen
│   ├── name_input_screen.dart  # User name collection
│   ├── dashboard_screen.dart   # Main task management screen
│   └── task_form_screen.dart   # Add/Edit task screen
└── theme/
    └── app_theme.dart          # App-wide theme configuration
```

## 🎯 Key Features Explained

### Task Management
- **Circular Checkbox**: Tap to toggle task completion
- **Strike-through Effect**: Completed tasks are visually distinguished
- **Priority Badges**: Color-coded flags for quick identification
- **Swipe/Tap to Edit**: Intuitive task editing
- **Delete with Confirmation**: Prevents accidental deletions

### Smart Filtering
- Toggle between All/Active/Completed tasks
- Real-time search across titles and descriptions
- Combined filtering and search capabilities

### Data Persistence
- All tasks stored locally using Hive
- User name saved for personalization
- First-time user detection
- Instant data access (offline-first)

## 🎨 UI Highlights

- **Gradient Backgrounds**: Soft purple-to-blue gradients
- **Card-Based Design**: Clean white cards with subtle shadows
- **Rounded Corners**: 16px border radius throughout
- **Spacious Layout**: Comfortable padding and margins
- **Material 3**: Modern Material Design 3 components
- **Custom FAB**: Gradient floating action button
- **Smooth Animations**: Polished interaction feedback

## 📝 Usage Guide

### Creating a Task
1. Tap the **+** floating action button
2. Enter task title (required)
3. Add description (optional)
4. Select due date and time
5. Choose priority level
6. Tap **Create Task**

### Editing a Task
1. Tap any task card
2. Modify details
3. Tap **Update Task**

### Completing a Task
- Tap the circular checkbox next to any task

### Deleting a Task
1. Tap the delete icon on a task card
2. Confirm deletion in the dialog

### Searching Tasks
- Use the search bar at the top of the dashboard
- Search works on both titles and descriptions

### Filtering Tasks
- Tap **All**, **Active**, or **Completed** tabs
- Combine with search for refined results

## 🔧 Customization

### Changing Colors
Edit [lib/theme/app_theme.dart](lib/theme/app_theme.dart) to customize:
- Primary colors
- Text colors
- Priority colors
- Background gradients

### Modifying Fonts
Update `AppTheme.lightTheme` in [lib/theme/app_theme.dart](lib/theme/app_theme.dart) to change the Google Font family.

## 🐛 Troubleshooting

### Hive Adapter Issues
If you encounter issues with Hive adapters:
```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Package Conflicts
```bash
flutter pub upgrade --major-versions
```

### Clear App Data (Testing)
```bash
flutter clean
flutter pub get
```

## 📄 License

This project is created for educational purposes.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive for fast local storage
- Google Fonts for beautiful typography
- Material Design for UI guidelines

---

**Built with ❤️ using Flutter**
