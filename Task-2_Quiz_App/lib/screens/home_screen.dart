import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../providers/user_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/category_provider.dart';
import '../widgets/user_stats_card.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/quiz_card.dart';
import '../widgets/category_card.dart';
import 'quiz_screen.dart';
import 'explore_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileProvider);
    final dailyChallenge = ref.watch(dailyChallengeProvider);
    final allQuizzes = ref.watch(quizzesProvider);
    final categories = ref.watch(categoriesProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    // Get in-progress quizzes (simulated with first 3 quizzes)
    final continuePlayingQuizzes = allQuizzes.take(3).toList();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryBlue, AppTheme.backgroundLight],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      // User Avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: AppTheme.accentGreen,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            userProfile.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Welcome text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              userProfile.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Notification icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Stats Card
                Center(
                  child: UserStatsCard(
                    streak: userProfile.currentStreak,
                    points: userProfile.totalPoints,
                  ),
                ),
                const SizedBox(height: 24),
                // Daily Challenge
                if (dailyChallenge != null) ...[
                  Center(
                    child: DailyChallengeCard(
                      quiz: dailyChallenge,
                      onStartQuiz: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => QuizScreen(quiz: dailyChallenge),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
                // Continue Playing Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Continue Playing',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExploreScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: AppTheme.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Continue Playing List
                SizedBox(
                  height: 175,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    itemCount: continuePlayingQuizzes.length,
                    itemBuilder: (context, index) {
                      final quiz = continuePlayingQuizzes[index];
                      return QuizCard(
                        quiz: quiz,
                        progressPercentage:
                            index == 0
                                ? 80
                                : index == 1
                                ? 50
                                : 30,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(quiz: quiz),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // Categories Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Text(
                    'Categories',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Categories Grid
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children:
                        categories.map((category) {
                          return CategoryCard(
                            category: category,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ExploreScreen(
                                        selectedCategory: category.name,
                                      ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
