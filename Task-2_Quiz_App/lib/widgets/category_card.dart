import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/quiz_category.dart';

class CategoryCard extends StatelessWidget {
  final QuizCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 64) / 2; // 2 columns with padding

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: category.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: category.color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: category.color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
