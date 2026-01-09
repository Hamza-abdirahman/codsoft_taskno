# 🎨 Tasky App - Features Overview

## 📱 Complete App Flow

```
┌─────────────────┐
│  Welcome Screen │  (First Time Only)
│   "Get Started" │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Name Input      │  (First Time Only)
│ "What's your    │
│  name?"         │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│         DASHBOARD SCREEN            │
│ ┌─────────────────────────────────┐ │
│ │ Hello, [Name] 👋                │ │
│ │ You have X pending tasks        │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  🔍  Search tasks...            │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌────────┐ ┌────────┐ ┌────────┐   │
│ │ Total  │ │ Active │ │  Done  │   │
│ │   12   │ │   7    │ │   5    │   │
│ └────────┘ └────────┘ └────────┘   │
│                                     │
│ [All] [Active] [Completed]          │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ○  Buy groceries                │ │
│ │    Get milk, eggs, bread        │ │
│ │    🕐 Dec 21 • 🏁 HIGH          │ │
│ │                            🗑️   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ○  Finish project report        │ │
│ │    Complete by end of week      │ │
│ │    🕐 Dec 23 • 🏁 MEDIUM        │ │
│ │                            🗑️   │ │
│ └─────────────────────────────────┘ │
│                                     │
│                              [+]    │ ← FAB
└─────────────────────────────────────┘
         │ (Tap + or Task)
         ▼
┌─────────────────────────────────────┐
│      ADD / EDIT TASK SCREEN         │
│                                     │
│ Task Title                          │
│ ┌─────────────────────────────────┐ │
│ │ Enter task title                │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Description (Optional)              │
│ ┌─────────────────────────────────┐ │
│ │ Add more details...             │ │
│ │                                 │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Due Date & Time                     │
│ ┌─────────────────────────────────┐ │
│ │ 📅 Friday, Dec 21, 2024 • 3:00PM│ │
│ └─────────────────────────────────┘ │
│                                     │
│ Priority                            │
│ ┌─────┐ ┌────────┐ ┌──────┐        │
│ │ Low │ │ Medium │ │ High │        │
│ └─────┘ └────────┘ └──────┘        │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │      CREATE TASK / UPDATE       │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

## ✅ Feature Checklist

### Screens (4/4)
- ✅ Welcome / Starting Screen
- ✅ Name Input Screen
- ✅ To-Do Dashboard
- ✅ Add / Edit Task Screen

### Core Features
- ✅ Add tasks
- ✅ Edit tasks
- ✅ Delete tasks (with confirmation)
- ✅ Toggle completion (circular checkbox)
- ✅ Task title (required)
- ✅ Task description (optional)
- ✅ Priority levels (Low/Medium/High)
- ✅ Due date with time
- ✅ Completion status
- ✅ Local persistence (Hive)
- ✅ Search by title/description
- ✅ Filter tabs (All/Active/Completed)
- ✅ Task statistics display

### Design Elements
- ✅ Modern, clean UI
- ✅ Purple primary color (#7C4DFF)
- ✅ Gradient background
- ✅ White cards with shadows
- ✅ Rounded corners (16px)
- ✅ Inter font family
- ✅ Priority color coding
- ✅ Circular FAB with gradient
- ✅ Material 3 design
- ✅ Empty state message

### Technical Implementation
- ✅ Hive local storage
- ✅ Google Fonts (Inter)
- ✅ intl date formatting
- ✅ uuid for unique IDs
- ✅ Clean architecture
- ✅ Proper state management
- ✅ Navigation routing

## 🎨 Color Reference

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary / Accent | Purple | `#7C4DFF` |
| Background | Light Purple | `#F9F5FF` |
| Gradient 1 | Lighter Purple | `#F3E8FF` |
| Gradient 2 | Blue Tint | `#EEF2FF` |
| Card Background | White | `#FFFFFF` |
| Primary Text | Dark Gray | `#111827` |
| Secondary Text | Medium Gray | `#6B7280` |
| Muted Text | Light Gray | `#9CA3AF` |
| Priority High | Red | `#EF4444` |
| Priority Medium | Amber | `#F59E0B` |
| Priority Low | Green | `#22C55E` |

## 📊 Data Model

```dart
Task {
  String id;              // UUID v4
  String title;           // Required
  String description;     // Optional
  String priority;        // 'low', 'medium', 'high'
  DateTime dueDate;       // Date + Time
  bool isCompleted;       // Default: false
  DateTime createdAt;     // Timestamp
}
```

## 🎯 User Interactions

| Action | Result |
|--------|--------|
| Tap FAB (+) | Navigate to Add Task Screen |
| Tap Task Card | Navigate to Edit Task Screen |
| Tap Circular Checkbox | Toggle task completion |
| Tap Delete Icon | Show delete confirmation dialog |
| Type in Search Bar | Filter tasks by title/description |
| Tap Filter Tab | Show All/Active/Completed tasks |
| Tap Date Selector | Open date & time picker |
| Tap Priority Button | Select priority level |
| Tap Save/Update | Save task and return to dashboard |

## 🚀 Ready to Run!

The app is fully implemented and ready to use:

```bash
flutter run
```

All dependencies are installed, Hive adapters are generated, and the code is formatted.

Enjoy your beautiful To-Do List app! 🎉
