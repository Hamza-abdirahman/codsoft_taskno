import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  child: const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Top 3 podium
                SizedBox(
                  height: 200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _PodiumItem(
                        rank: 2,
                        name: 'Sarah',
                        points: 950,
                        height: 140,
                        color: AppTheme.textSecondary,
                      ),
                      _PodiumItem(
                        rank: 1,
                        name: 'Alex',
                        points: 1200,
                        height: 180,
                        color: AppTheme.accentYellow,
                      ),
                      _PodiumItem(
                        rank: 3,
                        name: 'Mike',
                        points: 850,
                        height: 120,
                        color: Color(0xFFCD7F32),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Leaderboard list
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return _LeaderboardItem(
                        rank: index + 4,
                        name: 'Player ${index + 4}',
                        points: 800 - (index * 50),
                        isCurrentUser: index == 1, // Simulate current user
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final double height;
  final Color color;

  const _PodiumItem({
    required this.rank,
    required this.name,
    required this.points,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: color, width: 3),
          ),
          child: Center(
            child: Text(
              name[0],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryTeal,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$points pts',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withOpacity(0.8), color],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaderboardItem extends StatelessWidget {
  final int rank;
  final String name;
  final int points;
  final bool isCurrentUser;

  const _LeaderboardItem({
    required this.rank,
    required this.name,
    required this.points,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isCurrentUser
                ? AppTheme.primaryTeal.withOpacity(0.1)
                : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentUser ? AppTheme.primaryTeal : Colors.transparent,
          width: 2,
        ),
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.textSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryTeal.withOpacity(0.2),
            ),
            child: Center(
              child: Text(
                name[0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryTeal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$points',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryTeal,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'pts',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
