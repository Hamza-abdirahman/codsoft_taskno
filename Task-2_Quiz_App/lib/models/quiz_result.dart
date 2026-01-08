class QuizResult {
  final String quizId;
  final String quizTitle;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final Map<int, int> userAnswers;
  final Map<int, int> correctAnswersMap;
  final DateTime completedAt;
  final int pointsEarned;

  const QuizResult({
    required this.quizId,
    required this.quizTitle,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.userAnswers,
    required this.correctAnswersMap,
    required this.completedAt,
    required this.pointsEarned,
  });

  double get scorePercentage => (correctAnswers / totalQuestions) * 100;

  String get performanceMessage {
    if (scorePercentage >= 90) return 'EXCELLENT WORK!';
    if (scorePercentage >= 70) return 'GREAT JOB!';
    if (scorePercentage >= 50) return 'GOOD EFFORT!';
    return 'KEEP PRACTICING!';
  }
}
