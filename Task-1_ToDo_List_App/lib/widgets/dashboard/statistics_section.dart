import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/task.dart';
import 'metric_card.dart';

class StatisticsSection extends StatelessWidget {
  final VoidCallback onShowAll;
  final VoidCallback onShowTodayTasks;
  final VoidCallback onShowActive;
  final VoidCallback onShowCompleted;

  const StatisticsSection({
    super.key,
    required this.onShowAll,
    required this.onShowTodayTasks,
    required this.onShowActive,
    required this.onShowCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box>(
      future: Hive.openBox('settings'),
      builder: (context, settingsSnapshot) {
        if (!settingsSnapshot.hasData) {
          return Container(
            height: 140,
            margin: const EdgeInsets.symmetric(vertical: 12),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7C4DFF)),
              ),
            ),
          );
        }

        return ValueListenableBuilder<Box<Task>>(
          valueListenable: Hive.box<Task>('tasks').listenable(),
          builder: (context, box, _) {
            // Get today's date (start and end)
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = today.add(const Duration(days: 1));

            // Filter tasks for today only
            final todayTasks =
                box.values.where((task) {
                  final taskDate = DateTime(
                    task.dueDate.year,
                    task.dueDate.month,
                    task.dueDate.day,
                  );
                  return taskDate.isAtSameMomentAs(today) ||
                      (taskDate.isAfter(today) && taskDate.isBefore(tomorrow));
                }).toList();

            final totalTodayTasks = todayTasks.length;
            final completedTodayTasks =
                todayTasks.where((task) => task.isCompleted).length;
            final progressPercentage =
                totalTodayTasks > 0
                    ? (completedTodayTasks / totalTodayTasks * 100).round()
                    : 0;

            // Calculate overdue tasks
            final overdueTasks =
                box.values.where((task) {
                  if (task.isCompleted) return false;
                  final taskDate = DateTime(
                    task.dueDate.year,
                    task.dueDate.month,
                    task.dueDate.day,
                  );
                  return taskDate.isBefore(today);
                }).length;

            // Calculate total tasks
            final totalTasks = box.values.length;
            final allCompletedTasks =
                box.values.where((task) => task.isCompleted).length;
            final allPendingTasks = totalTasks - allCompletedTasks;

            return Container(
              height: 140,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                children: [
                  MetricCard(
                    icon: Icons.list_alt_rounded,
                    label: 'All Tasks',
                    value: '$totalTasks Total',
                    gradientColors: const [
                      Color(0xFF7C4DFF),
                      Color(0xFF6A3FD5),
                    ],
                    onTap: () {
                      onShowAll();
                    },
                  ),
                  const SizedBox(width: 12),
                  ValueListenableBuilder<Box>(
                    valueListenable:
                        settingsSnapshot.hasData
                            ? settingsSnapshot.data!.listenable()
                            : Hive.box('settings').listenable(),
                    builder: (context, settingsBox, _) {
                      final dailyGoal = settingsBox.get(
                        'dailyGoal',
                        defaultValue: 5,
                      );
                      final progress =
                          totalTodayTasks >= dailyGoal
                              ? 'Completed! 🎉'
                              : '${dailyGoal - totalTodayTasks} left';
                      return MetricCard(
                        icon: Icons.track_changes,
                        label: 'Daily Goal',
                        value: '$totalTodayTasks / $dailyGoal',
                        gradientColors:
                            totalTodayTasks >= dailyGoal
                                ? const [Color(0xFF2ecc71), Color(0xFF27ae60)]
                                : const [Color(0xFF1e3a5f), Color(0xFF2d4a6f)],
                        onTap: () {},
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.trending_up,
                    label: 'Progress',
                    value: '$progressPercentage%',
                    gradientColors: const [
                      Color(0xFF00d4ff),
                      Color(0xFF0099cc),
                    ],
                    onTap: onShowTodayTasks,
                  ),
                  if (overdueTasks > 0) ...[
                    const SizedBox(width: 12),
                    MetricCard(
                      icon: Icons.warning_rounded,
                      label: 'Overdue',
                      value:
                          '$overdueTasks Task${overdueTasks == 1 ? '' : 's'}',
                      gradientColors: const [
                        Color(0xFFff4757),
                        Color(0xFFff6348),
                      ],
                      onTap: () {
                        onShowActive();
                      },
                    ),
                  ],
                  const SizedBox(width: 12),
                  MetricCard(
                    icon: Icons.check_circle_rounded,
                    label: 'Completed Today',
                    value:
                        '$completedTodayTasks Task${completedTodayTasks == 1 ? '' : 's'}',
                    gradientColors: const [
                      Color(0xFF2ecc71),
                      Color(0xFF27ae60),
                    ],
                    onTap: () {
                      onShowCompleted();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
