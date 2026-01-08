import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz_progress.dart';
import '../models/quiz.dart';
import '../models/quiz_result.dart';

// Quiz progress state notifier
class QuizProgressNotifier extends StateNotifier<QuizProgress?> {
  QuizProgressNotifier() : super(null);

  void startQuiz(String quizId) {
    state = QuizProgress(quizId: quizId);
  }

  void selectAnswer(int questionIndex, int answerIndex) {
    if (state == null) return;

    final updatedAnswers = Map<int, int>.from(state!.selectedAnswers);
    updatedAnswers[questionIndex] = answerIndex;

    state = state!.copyWith(selectedAnswers: updatedAnswers);
  }

  void nextQuestion() {
    if (state == null) return;
    state = state!.copyWith(
      currentQuestionIndex: state!.currentQuestionIndex + 1,
    );
  }

  void completeQuiz(Quiz quiz) {
    if (state == null) return;

    int score = 0;
    final answers = state!.selectedAnswers;

    for (int i = 0; i < quiz.questions.length; i++) {
      if (answers[i] == quiz.questions[i].correctAnswerIndex) {
        score++;
      }
    }

    state = state!.copyWith(score: score, isCompleted: true);
  }

  QuizResult? getResult(Quiz quiz) {
    if (state == null || !state!.isCompleted) return null;

    final correctAnswersMap = <int, int>{};
    for (int i = 0; i < quiz.questions.length; i++) {
      correctAnswersMap[i] = quiz.questions[i].correctAnswerIndex;
    }

    final pointsEarned =
        (state!.score * 10) +
        (state!.score == quiz.questions.length
            ? 50
            : 0); // Bonus for perfect score

    return QuizResult(
      quizId: quiz.id,
      quizTitle: quiz.title,
      totalQuestions: quiz.questions.length,
      correctAnswers: state!.score,
      wrongAnswers: quiz.questions.length - state!.score,
      userAnswers: state!.selectedAnswers,
      correctAnswersMap: correctAnswersMap,
      completedAt: DateTime.now(),
      pointsEarned: pointsEarned,
    );
  }

  void resetQuiz() {
    state = null;
  }
}

// Quiz progress provider
final quizProgressProvider =
    StateNotifierProvider<QuizProgressNotifier, QuizProgress?>((ref) {
      return QuizProgressNotifier();
    });
