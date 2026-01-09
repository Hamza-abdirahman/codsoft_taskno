import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  String priority; // 'low', 'medium', 'high'

  @HiveField(4)
  DateTime dueDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String? categoryId;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
    this.categoryId,
  });

  // Create a copy with modifications
  Task copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? createdAt,
    String? categoryId,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
