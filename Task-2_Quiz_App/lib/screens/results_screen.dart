import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';
import '../providers/user_provider.dart';
import '../providers/quiz_progress_provider.dart';
import '../widgets/gradient_button.dart';

class ResultsScreen extends ConsumerWidget {
  final Quiz quiz;
  final QuizResult result;

  const ResultsScreen({super.key, required this.quiz, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Update user stats
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).updatePoints(result.pointsEarned);
      ref.read(userProfileProvider.notifier).incrementQuizzesCompleted();
      if (result.scorePercentage >= 70) {
        ref.read(userProfileProvider.notifier).incrementStreak();
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        ref.read(quizProgressProvider.notifier).resetQuiz();
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'RESULTS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Performance Message
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.cardGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  result.performanceMessage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Score Circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryTeal.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Progress ring
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: result.scorePercentage / 100,
                        strokeWidth: 12,
                        backgroundColor: AppTheme.textSecondary.withOpacity(
                          0.1,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          result.scorePercentage >= 70
                              ? AppTheme.successGreen
                              : result.scorePercentage >= 50
                              ? AppTheme.accentYellow
                              : AppTheme.errorRed,
                        ),
                      ),
                    ),
                    // Score text
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${result.scorePercentage.toInt()}%',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SCORE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Details text
              Text(
                'You answered ${result.correctAnswers} out of ${result.totalQuestions}',
                style: TextStyle(fontSize: 16, color: AppTheme.textPrimary),
              ),
              Text(
                'questions correctly.',
                style: TextStyle(fontSize: 16, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 32),
              // Stats Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.quiz,
                        label: 'TOTAL',
                        value: result.totalQuestions.toString(),
                        color: AppTheme.primaryTeal,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.check_circle,
                        label: 'CORRECT',
                        value: result.correctAnswers.toString(),
                        color: AppTheme.successGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.cancel,
                        label: 'WRONG',
                        value: result.wrongAnswers.toString(),
                        color: AppTheme.errorRed,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Review Answers Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  'Review Answers',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Answer review list - Show ALL answers
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: List.generate(result.totalQuestions, (index) {
                    final question = quiz.questions[index];
                    final userAnswer = result.userAnswers[index];
                    final correctAnswer = result.correctAnswersMap[index];
                    final isCorrect = userAnswer == correctAnswer;

                    return _AnswerReviewCard(
                      questionNumber: index + 1,
                      question: question.question,
                      userAnswer:
                          userAnswer != null
                              ? question.options[userAnswer]
                              : 'Not answered',
                      correctAnswer: question.options[correctAnswer!],
                      isCorrect: isCorrect,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),
              // Action Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Column(
                  children: [
                    GradientButton(
                      text: 'Play Again',
                      icon: Icons.refresh,
                      onPressed: () {
                        ref.read(quizProgressProvider.notifier).resetQuiz();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        // Share result
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.share,
                            color: AppTheme.primaryTeal,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Share Result',
                            style: TextStyle(
                              color: AppTheme.primaryTeal,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerReviewCard extends StatelessWidget {
  final int questionNumber;
  final String question;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;

  const _AnswerReviewCard({
    required this.questionNumber,
    required this.question,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isCorrect
                  ? AppTheme.successGreen.withOpacity(0.3)
                  : AppTheme.errorRed.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isCorrect
                      ? AppTheme.successGreen.withOpacity(0.1)
                      : AppTheme.errorRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCorrect ? Icons.check : Icons.close,
              color: isCorrect ? AppTheme.successGreen : AppTheme.errorRed,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Question $questionNumber',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  question,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (!isCorrect) ...[
                  Text(
                    'Your answer: $userAnswer',
                    style: TextStyle(fontSize: 13, color: AppTheme.errorRed),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  isCorrect
                      ? 'Your answer: $userAnswer ✓'
                      : 'Correct answer: $correctAnswer',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.successGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
