import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class AnswerOption extends StatelessWidget {
  final String label;
  final String answer;
  final bool isSelected;
  final VoidCallback onTap;
  final bool? isCorrect;

  const AnswerOption({
    super.key,
    required this.label,
    required this.answer,
    required this.isSelected,
    required this.onTap,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    Color backgroundColor;
    Color borderColor;
    Color textColor = AppTheme.textPrimary;
    IconData? icon;

    if (isCorrect != null) {
      if (isCorrect!) {
        backgroundColor = AppTheme.successGreen.withOpacity(0.1);
        borderColor = AppTheme.successGreen;
        textColor = AppTheme.successGreen;
        icon = Icons.check_circle;
      } else if (isSelected) {
        backgroundColor = AppTheme.errorRed.withOpacity(0.1);
        borderColor = AppTheme.errorRed;
        textColor = AppTheme.errorRed;
        icon = Icons.cancel;
      } else {
        backgroundColor = Colors.white;
        borderColor = AppTheme.textSecondary.withOpacity(0.3);
      }
    } else if (isSelected) {
      backgroundColor = AppTheme.primaryTeal.withOpacity(0.1);
      borderColor = AppTheme.primaryTeal;
      textColor = AppTheme.primaryTeal;
      icon = Icons.check_circle;
    } else {
      backgroundColor = Colors.white;
      borderColor = AppTheme.textSecondary.withOpacity(0.3);
    }

    return GestureDetector(
      onTap: isCorrect == null ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: screenWidth * 0.9,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isSelected || isCorrect != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: borderColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            // Label circle
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    isSelected || isCorrect != null
                        ? borderColor
                        : AppTheme.textSecondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color:
                        isSelected || isCorrect != null
                            ? Colors.white
                            : AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Answer text
            Expanded(
              child: Text(
                answer,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            // Check icon
            if (icon != null) Icon(icon, color: borderColor, size: 24),
          ],
        ),
      ),
    );
  }
}
