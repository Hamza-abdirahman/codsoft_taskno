class QuizProgress {
  final String quizId;
  final int currentQuestionIndex;
  final Map<int, int> selectedAnswers;
  final int score;
  final bool isCompleted;

  const QuizProgress({
    required this.quizId,
    this.currentQuestionIndex = 0,
    this.selectedAnswers = const {},
    this.score = 0,
    this.isCompleted = false,
  });

  QuizProgress copyWith({
    String? quizId,
    int? currentQuestionIndex,
    Map<int, int>? selectedAnswers,
    int? score,
    bool? isCompleted,
  }) {
    return QuizProgress(
      quizId: quizId ?? this.quizId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      score: score ?? this.score,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  int get correctAnswers => score;
  int get totalAnswered => selectedAnswers.length;
}
