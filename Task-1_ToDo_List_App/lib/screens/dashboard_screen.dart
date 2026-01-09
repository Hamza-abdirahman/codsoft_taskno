import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../models/notification_item.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/dashboard/statistics_section.dart';
import '../widgets/dashboard/task_cards.dart';
import '../widgets/dashboard/schedule_view.dart';
import '../widgets/dashboard/profile_view.dart';
import '../widgets/dashboard/dialogs.dart';
// import '../services/notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, active, completed
  String? _selectedCategoryId; // null means all categories
  int _currentNavIndex = 0; // Bottom navigation index

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure all boxes are open for ValueListenableBuilder
    _ensureBoxesOpen();
  }

  Future<void> _ensureBoxesOpen() async {
    if (!Hive.isBoxOpen('tasks')) {
      await Hive.openBox<Task>('tasks');
      print('✅ [initState] Tasks box opened');
    }
    if (!Hive.isBoxOpen('notifications')) {
      await Hive.openBox<NotificationItem>('notifications');
      print('✅ [initState] Notifications box opened');
    }
  }

  Future<void> _ensureNotificationsBoxOpen() async {
    if (!Hive.isBoxOpen('notifications')) {
      await Hive.openBox<NotificationItem>('notifications');
      print('✅ Notifications box opened');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotifications();
    }
  }

  Future<void> _refreshNotifications() async {
    // Reload notifications box to get changes from background isolate
    print('\n🔄 ========== REFRESHING NOTIFICATIONS ========== 🔄');
    try {
      // Simply ensure box is open - don't close it if UI is watching
      if (!Hive.isBoxOpen('notifications')) {
        print('📦 Box is closed, reopening...');
        await Hive.openBox<NotificationItem>('notifications');
        print('✅ Box reopened successfully');
      } else {
        print('� Box is already open');
      }

      final box = Hive.box<NotificationItem>('notifications');
      print('📦 Box path: ${box.path}');
      print('📊 Notification count: ${box.length}');

      // List all notifications
      print('📋 Notifications found:');
      for (var i = 0; i < box.length; i++) {
        final n = box.getAt(i);
        print('  [$i] ${n?.title} - ${n?.body}');
      }

      if (mounted) {
        setState(() {});
        print('✅ UI refreshed');
      }
      print('🔄 ========== REFRESH COMPLETED ========== 🔄\n');
    } catch (e, stack) {
      print('❌ Error refreshing notifications: $e');
      print('Stack: $stack');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    List<Task> filtered = tasks;

    // Apply filter
    if (_selectedFilter == 'active') {
      // Show overdue tasks (incomplete tasks with due date before today)
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      filtered =
          filtered.where((task) {
            if (task.isCompleted) return false;
            final taskDate = DateTime(
              task.dueDate.year,
              task.dueDate.month,
              task.dueDate.day,
            );
            return taskDate.isBefore(today);
          }).toList();
    } else if (_selectedFilter == 'completed') {
      filtered = filtered.where((task) => task.isCompleted).toList();
    }
    // 'all' shows everything (no filter applied)

    // Apply category filter
    if (_selectedCategoryId != null) {
      filtered =
          filtered
              .where((task) => task.categoryId == _selectedCategoryId)
              .toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered =
          filtered.where((task) {
            return task.title.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                task.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                );
          }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: _buildNotificationDrawer(),
      body:
          _currentNavIndex == 2
              ? const ProfileView()
              : _currentNavIndex == 1
              ? const ScheduleView()
              : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF9F5FF),
                      Color(0xFFF3E8FF),
                      Color(0xFFEEF2FF),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header
                      _buildHeader(),
                      // Search Bar
                      _buildSearchBar(),
                      // Statistics Cards
                      StatisticsSection(
                        onShowAll: () {
                          setState(() {
                            _selectedFilter = 'all';
                            _selectedCategoryId = null;
                            _searchQuery = '';
                            _searchController.clear();
                          });
                        },
                        onShowTodayTasks: () {
                          final now = DateTime.now();
                          final today = DateTime(now.year, now.month, now.day);
                          final tomorrow = today.add(const Duration(days: 1));
                          final box = Hive.box<Task>('tasks');
                          final todayTasks =
                              box.values.where((task) {
                                final taskDate = DateTime(
                                  task.dueDate.year,
                                  task.dueDate.month,
                                  task.dueDate.day,
                                );
                                return taskDate.isAtSameMomentAs(today) ||
                                    (taskDate.isAfter(today) &&
                                        taskDate.isBefore(tomorrow));
                              }).toList();
                          DashboardDialogs.showTodayTasksDialog(
                            context,
                            todayTasks,
                          );
                        },
                        onShowActive: () {
                          setState(() {
                            _selectedFilter = 'active';
                          });
                        },
                        onShowCompleted: () {
                          setState(() {
                            _selectedFilter = 'completed';
                          });
                        },
                      ),
                      // Categories Section
                      _buildCategoriesSection(),
                      // Task List
                      Expanded(child: _buildTaskList()),
                    ],
                  ),
                ),
              ),
      floatingActionButton: _currentNavIndex == 0 ? _buildFAB() : null,
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
                ),
              ),
            ),
          );
        }

        String userName = '';
        String profileImagePath = '';
        if (snapshot.hasData) {
          userName = snapshot.data!.get('userName', defaultValue: '') ?? '';
          profileImagePath =
              snapshot.data!.get('profileImagePath', defaultValue: '') ?? '';
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Row(
            children: [
              // Profile Circle Button (non-clickable, just for display)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: profileImagePath.isEmpty ? Colors.white : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    profileImagePath.isNotEmpty
                        ? ClipOval(
                          child: Image.file(
                            File(profileImagePath),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Center(
                          child: Text(
                            userName.isNotEmpty
                                ? userName
                                    .substring(0, userName.length >= 2 ? 2 : 1)
                                    .toUpperCase()
                                : '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF7C4DFF),
                            ),
                          ),
                        ),
              ),
              const SizedBox(width: 16),
              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isEmpty
                          ? 'Hello There! 👋'
                          : 'Hello, $userName 👋',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ValueListenableBuilder<Box<Task>>(
                      valueListenable: Hive.box<Task>('tasks').listenable(),
                      builder: (context, box, _) {
                        final activeTasks =
                            box.values
                                .where((task) => !task.isCompleted)
                                .length;
                        return Text(
                          activeTasks == 0
                              ? 'You have no pending tasks'
                              : 'You have $activeTasks pending ${activeTasks == 1 ? 'task' : 'tasks'}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6B7280),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Reminder Icon with Badge
              Transform.translate(
                offset: const Offset(0, -8),
                child: Builder(
                  builder: (context) {
                    // Double-check box is actually accessible
                    if (!Hive.isBoxOpen('notifications')) {
                      return IconButton(
                        onPressed: () async {
                          await _ensureNotificationsBoxOpen();
                          if (mounted) {
                            Scaffold.of(context).openEndDrawer();
                          }
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: Color(0xFF7C4DFF),
                          size: 26,
                        ),
                      );
                    }

                    // Try to get the box safely
                    Box<NotificationItem>? notificationBox;
                    try {
                      notificationBox = Hive.box<NotificationItem>(
                        'notifications',
                      );
                    } catch (e) {
                      // Box not found despite isBoxOpen check
                      return IconButton(
                        onPressed: () async {
                          await _ensureNotificationsBoxOpen();
                          if (mounted) {
                            Scaffold.of(context).openEndDrawer();
                          }
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: Color(0xFF7C4DFF),
                          size: 26,
                        ),
                      );
                    }

                    return ValueListenableBuilder<Box<NotificationItem>>(
                      valueListenable: notificationBox.listenable(),
                      builder: (context, box, _) {
                        // Safety check - ensure box is still open
                        if (!box.isOpen) {
                          return IconButton(
                            onPressed: () async {
                              await _ensureNotificationsBoxOpen();
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: Color(0xFF7C4DFF),
                              size: 26,
                            ),
                          );
                        }

                        final unreadCount =
                            box.values.where((n) => !n.isRead).length;
                        print(
                          '🔔 Total notifications: ${box.length}, Unread: $unreadCount',
                        );

                        return Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                print(
                                  '📱 Opening notification drawer with ${box.length} notifications',
                                );
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: Color(0xFF7C4DFF),
                                size: 26,
                              ),
                            ),
                            if (unreadCount > 0)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 18,
                                    minHeight: 18,
                                  ),
                                  child: Text(
                                    unreadCount > 9 ? '9+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          style: const TextStyle(fontSize: 15, color: Color(0xFF111827)),
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF9CA3AF),
            ),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Color(0xFF9CA3AF),
                      ),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _searchQuery = '';
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Row(
        children: [
          _buildFilterChip('All', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Active', 'active'),
          const SizedBox(width: 8),
          _buildFilterChip('Completed', 'completed'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C4DFF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF7C4DFF) : const Color(0xFFE5E7EB),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return ValueListenableBuilder<Box<Category>>(
      valueListenable: Hive.box<Category>('categories').listenable(),
      builder: (context, categoryBox, _) {
        if (categoryBox.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            SizedBox(
              height: 68,
              child: ValueListenableBuilder<Box<Task>>(
                valueListenable: Hive.box<Task>('tasks').listenable(),
                builder: (context, taskBox, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: categoryBox.length,
                    itemBuilder: (context, index) {
                      final category = categoryBox.getAt(index);
                      if (category == null) return const SizedBox.shrink();

                      // Count tasks in this category
                      final taskCount =
                          taskBox.values
                              .where((task) => task.categoryId == category.id)
                              .length;

                      // Parse category color
                      final colorValue = int.parse(
                        'FF${category.color.replaceFirst('#', '')}',
                        radix: 16,
                      );
                      final categoryColor = Color(colorValue);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryId =
                                _selectedCategoryId == category.id
                                    ? null
                                    : category.id;
                          });
                        },
                        child: Container(
                          width: 140,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  _selectedCategoryId == category.id
                                      ? categoryColor
                                      : categoryColor.withOpacity(0.3),
                              width: _selectedCategoryId == category.id ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: categoryColor.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: categoryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    category.icon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: categoryColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildTaskList() {
    // Check if tasks box is open
    if (!Hive.isBoxOpen('tasks')) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Loading tasks...'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _ensureBoxesOpen();
                setState(() {});
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ValueListenableBuilder<Box<Task>>(
      valueListenable: Hive.box<Task>('tasks').listenable(),
      builder: (context, box, _) {
        final allTasks = box.values.toList();
        final filteredTasks = _getFilteredTasks(allTasks);

        if (filteredTasks.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return TaskCard(
              task: task,
              onDelete: () => DashboardDialogs.showDeleteDialog(context, task),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt_rounded,
            size: 80,
            color: const Color(0xFF7C4DFF).withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create your first task!',
            style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF7C4DFF),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C4DFF).withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TaskFormDialog(),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add_rounded, size: 32),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            activeIcon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationDrawer() {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF9F5FF), Color(0xFFF3E8FF), Color(0xFFEEF2FF)],
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7C4DFF), Color(0xFF9C27B0)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<Box<NotificationItem>>(
                    valueListenable:
                        Hive.box<NotificationItem>(
                          'notifications',
                        ).listenable(),
                    builder: (context, box, _) {
                      if (box.isNotEmpty) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () {
                              // Clear all notifications
                              box.clear();
                            },
                            icon: const Icon(
                              Icons.clear_all,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            // Notification List
            Expanded(
              child: Builder(
                builder: (context) {
                  // Double-check box is actually accessible
                  if (!Hive.isBoxOpen('notifications')) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Loading notifications...',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await _ensureNotificationsBoxOpen();
                              setState(() {});
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Try to get the box safely
                  Box<NotificationItem>? notificationBox;
                  try {
                    notificationBox = Hive.box<NotificationItem>(
                      'notifications',
                    );
                  } catch (e) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading notifications',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () async {
                              await _ensureNotificationsBoxOpen();
                              setState(() {});
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ValueListenableBuilder<Box<NotificationItem>>(
                    valueListenable: notificationBox.listenable(),
                    builder: (context, box, _) {
                      print(
                        '📬 Notification drawer building with ${box.length} notifications',
                      );

                      // Log each notification
                      for (var i = 0; i < box.length; i++) {
                        final notif = box.getAt(i);
                        print(
                          '  [$i] ${notif?.title} - ${notif?.body} (${notif?.receivedAt})',
                        );
                      }

                      if (box.isEmpty) {
                        print('📭 Notification box is empty');
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_none,
                                size: 80,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No notifications yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You\'ll see task reminders here',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Get notifications sorted by most recent first
                      final notifications =
                          box.values.toList()..sort(
                            (a, b) => b.receivedAt.compareTo(a.receivedAt),
                          );

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];
                          return _buildNotificationCard(notification);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final timeFormat = DateFormat('MMM dd, yyyy • hh:mm a');
    final now = DateTime.now();
    final difference = now.difference(notification.receivedAt);

    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inHours < 1) {
      timeAgo = '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      timeAgo = '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      timeAgo = '${difference.inDays}d ago';
    } else {
      timeAgo = timeFormat.format(notification.receivedAt);
    }

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        notification.delete();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFF3E8FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                notification.isRead
                    ? const Color(0xFFE5E7EB)
                    : const Color(0xFF7C4DFF).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFF7C4DFF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF7C4DFF),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              notification.body,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
