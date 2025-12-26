import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class LearningStatisticsSection extends StatelessWidget {
  const LearningStatisticsSection({
    super.key,
    required this.theme,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.completedSurahs,
  });

  final ThemeData theme;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int completedSurahs;

  @override
  Widget build(BuildContext context) {
    final double accuracy = answeredQuestions == 0
      ? 0.0
      : (correctAnswers / answeredQuestions) * 100;

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
            'إحصائيات التعلم',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppColors.spacingLarge),
          _StatTile(
            theme: theme,
            icon: Icons.book_outlined,
            label: 'السور المكتملة',
            value: '$completedSurahs',
            color: Colors.blue,
          ),
          const SizedBox(height: AppColors.spacingMedium),
          _StatTile(
            theme: theme,
            icon: Icons.quiz_outlined,
            label: 'الأسئلة المجابة',
            value: '$answeredQuestions / $totalQuestions',
            color: Colors.green,
          ),
          const SizedBox(height: AppColors.spacingMedium),
          _StatTile(
            theme: theme,
            icon: Icons.check_circle_outline,
            label: 'نسبة الإجابات الصحيحة',
            value: '${accuracy.toStringAsFixed(1)}%',
            color: AppColors.getAccuracyColor(accuracy),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.theme,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final ThemeData theme;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppColors.spacingMedium),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppColors.spacingMedium),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
