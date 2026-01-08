import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/quiz.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final int? progressPercentage;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onTap,
    this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.38;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Image/Icon
            Container(
              height: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryTeal.withOpacity(0.7),
                    AppTheme.primaryBlue.withOpacity(0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      _getQuizIcon(quiz.title, quiz.category),
                      size: 50,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  if (progressPercentage != null)
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.textPrimary.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$progressPercentage%',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.025,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Quiz Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                      fontSize: screenWidth * 0.035,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    quiz.category,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryTeal,
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getQuizIcon(String title, String category) {
    // Check for specific quiz titles first
    if (title.toLowerCase().contains('space')) {
      return Icons.rocket_launch;
    }
    
    // Fall back to category-based icons
    switch (category.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.account_balance;
      case 'geography':
        return Icons.public;
      case 'arts':
        return Icons.palette;
      default:
        return Icons.quiz;
    }
  }
}
