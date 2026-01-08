import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class UserStatsCard extends StatelessWidget {
  final int streak;
  final int points;

  const UserStatsCard({super.key, required this.streak, required this.points});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryTeal.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryTeal.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department,
              label: 'Streak',
              value: '$streak Days',
              color: AppTheme.accentOrange,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppTheme.primaryTeal.withOpacity(0.3),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.star,
              label: 'Points',
              value: points.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
              color: AppTheme.accentYellow,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
