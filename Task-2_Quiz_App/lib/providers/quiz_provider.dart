import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../models/quiz_question.dart';

// Sample quiz data
final quizzesProvider = Provider<List<Quiz>>((ref) {
  return [
    Quiz(
      id: 'space-exploration',
      title: 'Space Exploration',
      description: 'Test your knowledge about the solar system and beyond.',
      category: 'Science',
      difficulty: QuizDifficulty.easy,
      isDailyChallenge: true,
      questions: [
        const QuizQuestion(
          id: 'q1',
          question: 'What is the largest planet in our solar system?',
          options: ['Earth', 'Jupiter', 'Saturn', 'Mars'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q2',
          question: 'Which planet is known as the Red Planet?',
          options: ['Venus', 'Jupiter', 'Mars', 'Mercury'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q3',
          question: 'How many planets are in our solar system?',
          options: ['7', '8', '9', '10'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q4',
          question: 'What is the chemical symbol for Gold?',
          options: ['Ag', 'Au', 'Fe', 'Gd'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q5',
          question: 'What is the closest star to Earth?',
          options: ['Alpha Centauri', 'Sirius', 'The Sun', 'Proxima Centauri'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q6',
          question: 'What galaxy is Earth located in?',
          options: ['Andromeda', 'Milky Way', 'Triangulum', 'Whirlpool'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q7',
          question: 'What is the smallest planet in our solar system?',
          options: ['Mars', 'Mercury', 'Venus', 'Pluto'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q8',
          question:
              'How long does it take for light from the Sun to reach Earth?',
          options: ['8 seconds', '8 minutes', '8 hours', '8 days'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q9',
          question: 'What is the name of Saturn\'s largest moon?',
          options: ['Europa', 'Titan', 'Ganymede', 'Callisto'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q10',
          question: 'What causes the northern lights (Aurora Borealis)?',
          options: [
            'Reflection of ice',
            'Solar wind particles',
            'Volcanic activity',
            'Moon reflection',
          ],
          correctAnswerIndex: 1,
        ),
      ],
    ),
    Quiz(
      id: 'ancient-history',
      title: 'Ancient History',
      description: 'Explore the fascinating world of ancient civilizations.',
      category: 'History',
      difficulty: QuizDifficulty.medium,
      questions: [
        const QuizQuestion(
          id: 'q1',
          question: 'What is the capital of France?',
          options: ['London', 'Paris', 'Berlin', 'Madrid'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q2',
          question: 'Who painted the Mona Lisa?',
          options: ['Michelangelo', 'Da Vinci', 'Raphael', 'Donatello'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q3',
          question: 'In which year did World War II end?',
          options: ['1943', '1944', '1945', '1946'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q4',
          question: 'What was the name of the ancient Egyptian writing system?',
          options: ['Cuneiform', 'Hieroglyphics', 'Sanskrit', 'Latin'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q5',
          question: 'Who was the first Roman Emperor?',
          options: ['Julius Caesar', 'Augustus', 'Nero', 'Caligula'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q6',
          question: 'Which ancient wonder is still standing?',
          options: [
            'Hanging Gardens',
            'Colossus of Rhodes',
            'Great Pyramid of Giza',
            'Lighthouse of Alexandria',
          ],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q7',
          question: 'What year was the Magna Carta signed?',
          options: ['1215', '1315', '1415', '1515'],
          correctAnswerIndex: 0,
        ),
        const QuizQuestion(
          id: 'q8',
          question: 'Who was the Greek god of the sea?',
          options: ['Zeus', 'Hades', 'Poseidon', 'Apollo'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q9',
          question: 'Which empire built Machu Picchu?',
          options: ['Aztec', 'Maya', 'Inca', 'Olmec'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q10',
          question: 'What was the name of Alexander the Great\'s horse?',
          options: ['Pegasus', 'Bucephalus', 'Thunderbolt', 'Shadowfax'],
          correctAnswerIndex: 1,
        ),
      ],
    ),
    Quiz(
      id: 'general-science',
      title: 'General Science',
      description: 'Test your understanding of basic scientific concepts.',
      category: 'Science',
      difficulty: QuizDifficulty.medium,
      questions: [
        const QuizQuestion(
          id: 'q1',
          question: 'What is H2O commonly known as?',
          options: ['Oxygen', 'Hydrogen', 'Water', 'Carbon dioxide'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q2',
          question: 'What is the speed of light?',
          options: [
            '299,792 km/s',
            '150,000 km/s',
            '500,000 km/s',
            '100,000 km/s',
          ],
          correctAnswerIndex: 0,
        ),
        const QuizQuestion(
          id: 'q3',
          question: 'What is the powerhouse of the cell?',
          options: ['Nucleus', 'Ribosome', 'Mitochondria', 'Chloroplast'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q4',
          question: 'What is the chemical symbol for Iron?',
          options: ['Ir', 'Fe', 'In', 'Io'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q5',
          question: 'How many bones are in the human body?',
          options: ['196', '206', '216', '226'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q6',
          question: 'What gas do plants absorb from the atmosphere?',
          options: ['Oxygen', 'Nitrogen', 'Carbon dioxide', 'Hydrogen'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q7',
          question: 'What is the smallest unit of life?',
          options: ['Atom', 'Molecule', 'Cell', 'Organism'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q8',
          question: 'What force keeps planets in orbit around the sun?',
          options: ['Magnetism', 'Gravity', 'Nuclear force', 'Friction'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q9',
          question: 'What is the process by which plants make food?',
          options: [
            'Respiration',
            'Digestion',
            'Photosynthesis',
            'Fermentation',
          ],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q10',
          question: 'What is the hardest natural substance on Earth?',
          options: ['Gold', 'Iron', 'Diamond', 'Platinum'],
          correctAnswerIndex: 2,
        ),
      ],
    ),
    Quiz(
      id: 'world-geography',
      title: 'World Geography',
      description: 'Discover fascinating facts about our planet Earth.',
      category: 'Geography',
      difficulty: QuizDifficulty.easy,
      questions: [
        const QuizQuestion(
          id: 'q1',
          question: 'What is the largest country by land area?',
          options: ['Canada', 'Russia', 'China', 'United States'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q2',
          question: 'Which river is the longest in the world?',
          options: ['Amazon', 'Nile', 'Yangtze', 'Mississippi'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q3',
          question: 'What is the capital of Australia?',
          options: ['Sydney', 'Melbourne', 'Canberra', 'Brisbane'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q4',
          question: 'Which ocean is the largest?',
          options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
          correctAnswerIndex: 3,
        ),
        const QuizQuestion(
          id: 'q5',
          question: 'What is the smallest continent?',
          options: ['Europe', 'Australia', 'Antarctica', 'South America'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q6',
          question: 'Which country has the most islands?',
          options: ['Sweden', 'Finland', 'Norway', 'Indonesia'],
          correctAnswerIndex: 0,
        ),
        const QuizQuestion(
          id: 'q7',
          question: 'What is the highest mountain in the world?',
          options: ['K2', 'Mount Everest', 'Kangchenjunga', 'Lhotse'],
          correctAnswerIndex: 1,
        ),
        const QuizQuestion(
          id: 'q8',
          question: 'Which desert is the largest in the world?',
          options: ['Sahara', 'Arabian', 'Gobi', 'Antarctic'],
          correctAnswerIndex: 3,
        ),
        const QuizQuestion(
          id: 'q9',
          question: 'What is the capital of Japan?',
          options: ['Osaka', 'Kyoto', 'Tokyo', 'Hiroshima'],
          correctAnswerIndex: 2,
        ),
        const QuizQuestion(
          id: 'q10',
          question: 'Which country is known as the Land of the Rising Sun?',
          options: ['China', 'Japan', 'South Korea', 'Thailand'],
          correctAnswerIndex: 1,
        ),
      ],
    ),
  ];
});

// Filter quizzes by category
final quizzesByCategoryProvider = Provider.family<List<Quiz>, String>((
  ref,
  category,
) {
  final allQuizzes = ref.watch(quizzesProvider);
  if (category == 'All') return allQuizzes;
  return allQuizzes.where((quiz) => quiz.category == category).toList();
});

// Get daily challenge quiz
final dailyChallengeProvider = Provider<Quiz?>((ref) {
  final allQuizzes = ref.watch(quizzesProvider);
  try {
    return allQuizzes.firstWhere((quiz) => quiz.isDailyChallenge);
  } catch (e) {
    return null;
  }
});

// Get featured quizzes
final featuredQuizzesProvider = Provider<List<Quiz>>((ref) {
  final allQuizzes = ref.watch(quizzesProvider);
  return allQuizzes.where((quiz) => quiz.isFeatured).toList();
});
