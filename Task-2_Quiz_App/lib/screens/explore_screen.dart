import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../providers/quiz_provider.dart';
import '../models/quiz.dart';
import 'quiz_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  final String? selectedCategory;

  const ExploreScreen({super.key, this.selectedCategory});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String selectedFilter = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.selectedCategory != null) {
      selectedFilter = widget.selectedCategory!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allQuizzes = ref.watch(quizzesProvider);
    final filteredQuizzes =
        selectedFilter == 'All'
            ? allQuizzes
            : allQuizzes.where((q) => q.category == selectedFilter).toList();

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        elevation: 0,
        title: const Text(
          'Explore Quizzes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        key: const PageStorageKey('explore_scroll'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.primaryBlue, AppTheme.backgroundLight],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ready to\nchallenge yourself?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Featured Quiz Card
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFB347), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/featured_bg.png'),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: const Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        const Text(
                          'Surprise Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Test your knowledge across all categories\nwith a random set of questions.',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Start random quiz
                            if (allQuizzes.isNotEmpty) {
                              final randomQuiz = allQuizzes[0];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => QuizScreen(quiz: randomQuiz),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.shuffle),
                          label: const Text('Start Random Quiz'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search topics...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppTheme.primaryTeal,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter chips
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      children: [
                        _FilterChip(
                          label: 'All',
                          isSelected: selectedFilter == 'All',
                          onTap: () => setState(() => selectedFilter = 'All'),
                        ),
                        _FilterChip(
                          label: 'Trending',
                          isSelected: selectedFilter == 'Trending',
                          onTap:
                              () => setState(() => selectedFilter = 'Trending'),
                        ),
                        _FilterChip(
                          label: 'Science & Tech',
                          isSelected: selectedFilter == 'Science',
                          onTap:
                              () => setState(() => selectedFilter = 'Science'),
                        ),
                        _FilterChip(
                          label: 'History',
                          isSelected: selectedFilter == 'History',
                          onTap:
                              () => setState(() => selectedFilter = 'History'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Quiz List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = filteredQuizzes[index];
                return _QuizListItem(
                  quiz: quiz,
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
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryTeal : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _QuizListItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;

  const _QuizListItem({required this.quiz, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(quiz.category),
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _getDifficultyColor(quiz.difficulty).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                quiz.difficulty.name.toUpperCase(),
                style: TextStyle(
                  color: _getDifficultyColor(quiz.difficulty),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'science':
        return Icons.science;
      case 'history':
        return Icons.account_balance;
      case 'geography':
        return Icons.public;
      case 'arts':
        return Icons.palette;
      default:
        return Icons.quiz;
    }
  }

  Color _getDifficultyColor(QuizDifficulty difficulty) {
    switch (difficulty) {
      case QuizDifficulty.easy:
        return AppTheme.successGreen;
      case QuizDifficulty.medium:
        return AppTheme.accentYellow;
      case QuizDifficulty.hard:
        return AppTheme.errorRed;
    }
  }
}
