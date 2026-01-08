import 'quiz_question.dart';

enum QuizDifficulty { easy, medium, hard }

class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<QuizQuestion> questions;
  final QuizDifficulty difficulty;
  final String? imageUrl;
  final bool isFeatured;
  final bool isDailyChallenge;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.questions,
    this.difficulty = QuizDifficulty.medium,
    this.imageUrl,
    this.isFeatured = false,
    this.isDailyChallenge = false,
  });

  Quiz copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    List<QuizQuestion>? questions,
    QuizDifficulty? difficulty,
    String? imageUrl,
    bool? isFeatured,
    bool? isDailyChallenge,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      questions: questions ?? this.questions,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      isDailyChallenge: isDailyChallenge ?? this.isDailyChallenge,
    );
  }
}
