import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../models/quiz.dart';
import 'gradient_button.dart';
import 'gradient_card.dart';

class DailyChallengeCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onStartQuiz;

  const DailyChallengeCard({
    super.key,
    required this.quiz,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GradientCard(
      gradient: AppTheme.orangeGradient,
      width: screenWidth * 0.9,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with badge
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'DAILY CHALLENGE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Quiz content area with decorative elements
          Container(
            height: 140,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -20,
                  top: 10,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ),
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quiz.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Button area
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: GradientButton(
              text: 'START QUIZ',
              onPressed: onStartQuiz,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
