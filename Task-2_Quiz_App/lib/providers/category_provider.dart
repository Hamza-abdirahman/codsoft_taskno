import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_category.dart';

final categoriesProvider = Provider<List<QuizCategory>>((ref) {
  return const [
    QuizCategory(
      id: 'science',
      name: 'Science',
      icon: Icons.science,
      color: Color(0xFF7B68EE),
    ),
    QuizCategory(
      id: 'history',
      name: 'History',
      icon: Icons.account_balance,
      color: Color(0xFFE67E22),
    ),
    QuizCategory(
      id: 'geography',
      name: 'Geography',
      icon: Icons.public,
      color: Color(0xFF27AE60),
    ),
    QuizCategory(
      id: 'arts',
      name: 'Arts',
      icon: Icons.palette,
      color: Color(0xFFE74C3C),
    ),
  ];
});
