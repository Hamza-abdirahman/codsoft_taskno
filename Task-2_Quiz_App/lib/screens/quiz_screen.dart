import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../models/quiz.dart';
import '../providers/quiz_progress_provider.dart';
import '../widgets/question_card.dart';
import '../widgets/answer_option.dart';
import '../widgets/gradient_button.dart';
import 'results_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final Quiz quiz;

  const QuizScreen({super.key, required this.quiz});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    // Initialize quiz progress
    Future.microtask(() {
      ref.read(quizProgressProvider.notifier).startQuiz(widget.quiz.id);
    });
  }

  void _submitAnswer() {
    final progress = ref.read(quizProgressProvider);
    if (progress == null || selectedAnswerIndex == null) return;

    final currentIndex = progress.currentQuestionIndex;

    // Save the answer
    ref
        .read(quizProgressProvider.notifier)
        .selectAnswer(currentIndex, selectedAnswerIndex!);

    // Check if this is the last question
    if (currentIndex >= widget.quiz.questions.length - 1) {
      // Complete quiz
      ref.read(quizProgressProvider.notifier).completeQuiz(widget.quiz);
      final result = ref
          .read(quizProgressProvider.notifier)
          .getResult(widget.quiz);

      if (result != null) {
        // Navigate to results
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => ResultsScreen(quiz: widget.quiz, result: result),
          ),
        );
      }
    } else {
      // Move to next question
      ref.read(quizProgressProvider.notifier).nextQuestion();
      setState(() {
        selectedAnswerIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(quizProgressProvider);

    if (progress == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentIndex = progress.currentQuestionIndex;
    final currentQuestion = widget.quiz.questions[currentIndex];
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.backgroundLight, AppTheme.backgroundLight],
          ),
        ),
        child: SafeArea(
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
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Exit Quiz?'),
                                content: const Text(
                                  'Your progress will be lost. Are you sure you want to exit?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(quizProgressProvider.notifier)
                                          .resetQuiz();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Exit'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'QUIZ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppTheme.successGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                widget.quiz.category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Close button
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Exit Quiz?'),
                                content: const Text(
                                  'Your progress will be lost. Are you sure you want to exit?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ref
                                          .read(quizProgressProvider.notifier)
                                          .resetQuiz();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Exit'),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Progress indicator
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${currentIndex + 1}'.padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryTeal,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 100,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  (currentIndex + 1) /
                                  widget.quiz.questions.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryTeal,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.quiz.questions.length.toString().padLeft(
                              2,
                              '0',
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Question Card
              Center(
                child: QuestionCard(
                  question: currentQuestion.question,
                  questionNumber: currentIndex + 1,
                  totalQuestions: widget.quiz.questions.length,
                  hint: currentQuestion.hint,
                ),
              ),
              const SizedBox(height: 32),
              // Answer Options
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    children: List.generate(currentQuestion.options.length, (
                      index,
                    ) {
                      final labels = ['A', 'B', 'C', 'D'];
                      return AnswerOption(
                        label: labels[index],
                        answer: currentQuestion.options[index],
                        isSelected: selectedAnswerIndex == index,
                        onTap: () {
                          setState(() {
                            selectedAnswerIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),
              // Submit Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: 20,
                ),
                child: GradientButton(
                  text:
                      currentIndex >= widget.quiz.questions.length - 1
                          ? 'Submit Answer'
                          : 'Next Question',
                  onPressed:
                      selectedAnswerIndex != null ? _submitAnswer : () {},
                  gradient:
                      selectedAnswerIndex != null
                          ? AppTheme.buttonGradient
                          : LinearGradient(
                            colors: [
                              AppTheme.textSecondary.withOpacity(0.5),
                              AppTheme.textSecondary.withOpacity(0.5),
                            ],
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
