import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({
    super.key,
    required this.theme,
    required this.achievements,
  });

  final ThemeData theme;
  final List<String> achievements;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppColors.spacingLarge),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إنجازاتك',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppColors.spacingLarge),
          if (achievements.isEmpty)
            Text(
              'لا توجد إنجازات حالياً، واصل التقدم!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            )
          else
            Wrap(
              spacing: AppColors.spacingMedium,
              runSpacing: AppColors.spacingMedium,
              children: achievements
                  .map(
                    (achievement) => Chip(
                      label: Text(achievement),
                      avatar: const Icon(Icons.emoji_events, color: Colors.amber),
                      backgroundColor: theme.colorScheme.surfaceVariant,
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
