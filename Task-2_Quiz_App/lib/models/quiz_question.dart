class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? hint;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.hint,
  });

  QuizQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
    String? hint,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      hint: hint ?? this.hint,
    );
  }
}
