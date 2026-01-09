import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../task_form_dialog.dart';

class TodayTaskCard extends StatelessWidget {
  final Task task;

  const TodayTaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          GestureDetector(
            onTap: () {
              final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
              task.delete();
              final box = Hive.box<Task>('tasks');
              box.put(task.id, updatedTask);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      task.isCompleted
                          ? const Color(0xFF7C4DFF)
                          : const Color(0xFF9CA3AF),
                  width: 2,
                ),
                color:
                    task.isCompleted
                        ? const Color(0xFF7C4DFF)
                        : Colors.transparent,
              ),
              child:
                  task.isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
            ),
          ),
          const SizedBox(width: 12),
          // Task Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color:
                        task.isCompleted
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF111827),
                    decoration:
                        task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                  ),
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          task.isCompleted
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                      decoration:
                          task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      timeFormat.format(task.dueDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.flag_rounded,
                      size: 14,
                      color:
                          task.isCompleted
                              ? const Color(0xFF9CA3AF)
                              : priorityColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            task.isCompleted
                                ? const Color(0xFF9CA3AF)
                                : priorityColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFF22C55E);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(task.priority);
    final dateFormat = DateFormat('MMM dd, yyyy • hh:mm a');

    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => TaskFormDialog(task: task),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox
            GestureDetector(
              onTap: () {
                final updatedTask = task.copyWith(
                  isCompleted: !task.isCompleted,
                );
                task.delete();
                final box = Hive.box<Task>('tasks');
                box.put(task.id, updatedTask);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        task.isCompleted
                            ? const Color(0xFF7C4DFF)
                            : const Color(0xFF9CA3AF),
                    width: 2,
                  ),
                  color:
                      task.isCompleted
                          ? const Color(0xFF7C4DFF)
                          : Colors.transparent,
                ),
                child:
                    task.isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
              ),
            ),
            const SizedBox(width: 12),
            // Task Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          task.isCompleted
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF111827),
                      decoration:
                          task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      decorationColor: const Color(0xFF9CA3AF),
                    ),
                  ),
                  // Category Badge
                  if (task.categoryId != null) ...[
                    const SizedBox(height: 6),
                    CategoryBadge(categoryId: task.categoryId!),
                  ],
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            task.isCompleted
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                        decoration:
                            task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                        decorationColor: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Date and Priority
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateFormat.format(task.dueDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF9CA3AF),
                              decoration:
                                  task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag_rounded,
                            size: 14,
                            color:
                                task.isCompleted
                                    ? const Color(0xFF9CA3AF)
                                    : priorityColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.priority.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  task.isCompleted
                                      ? const Color(0xFF9CA3AF)
                                      : priorityColor,
                              decoration:
                                  task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Delete Button
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFFEF4444),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFF22C55E);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF9CA3AF);
    }
  }
}

class CategoryBadge extends StatelessWidget {
  final String categoryId;

  const CategoryBadge({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final categoryBox = Hive.box<Category>('categories');
    final category = categoryBox.values.firstWhere(
      (cat) => cat.id == categoryId,
      orElse:
          () => Category(
            id: '',
            name: 'Unknown',
            icon: '📁',
            color: '#9CA3AF',
            createdAt: DateTime.now(),
          ),
    );

    if (category.id.isEmpty) return const SizedBox.shrink();

    final colorValue = int.parse(
      'FF${category.color.replaceFirst('#', '')}',
      radix: 16,
    );
    final categoryColor = Color(colorValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(category.icon, style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: categoryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleTaskCard extends StatefulWidget {
  final Task task;

  const ScheduleTaskCard({super.key, required this.task});

  @override
  State<ScheduleTaskCard> createState() => _ScheduleTaskCardState();
}

class _ScheduleTaskCardState extends State<ScheduleTaskCard> {
  @override
  Widget build(BuildContext context) {
    final categoryBox = Hive.box<Category>('categories');
    final category = categoryBox.values.firstWhere(
      (cat) => cat.id == widget.task.categoryId,
      orElse:
          () => Category(
            id: 'default',
            name: 'General',
            icon: '📋',
            color: '#9CA3AF',
            createdAt: DateTime.now(),
          ),
    );

    final colorValue = int.parse(
      'FF${category.color.replaceFirst('#', '')}',
      radix: 16,
    );
    final categoryColor = Color(colorValue);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: categoryColor.withOpacity(0.3), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: categoryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(category.icon, style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(
          widget.task.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF111827),
            decoration:
                widget.task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                widget.task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  decoration:
                      widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 12,
                      color: categoryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  DateFormat('h:mm a').format(widget.task.dueDate),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Checkbox(
          value: widget.task.isCompleted,
          onChanged: (value) {
            setState(() {
              final updatedTask = widget.task.copyWith(
                isCompleted: value ?? false,
              );
              widget.task.delete();
              final box = Hive.box<Task>('tasks');
              box.put(widget.task.id, updatedTask);
            });
          },
          activeColor: const Color(0xFF7C4DFF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => TaskFormDialog(task: widget.task),
          );
        },
      ),
    );
  }
}
