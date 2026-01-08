import 'package:flutter/material.dart';

class QuizCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
