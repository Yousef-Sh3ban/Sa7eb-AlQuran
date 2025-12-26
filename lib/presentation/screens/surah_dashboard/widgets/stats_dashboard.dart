import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/stats_calculator.dart';

class StatsDashboard extends StatelessWidget {
  const StatsDashboard({
    super.key,
    required this.stats,
  });

  final QuestionStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: AppColors.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingXXLarge),
        child: Column(
          children: [
            Center(child: _Badge(stats: stats)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CircularIndicator(
                  label: 'الدقة',
                  value: stats.accuracyRate,
                  color: AppColors.getAccuracyColor(stats.accuracyRate),
                ),
                _CircularIndicator(
                  label: 'التقدم',
                  value: stats.completionRate,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: AppColors.spacingLarge),
            _StatsCards(stats: stats),
          ],
        ),
      ),
    );
  }
}

class _StatsCards extends StatelessWidget {
  const _StatsCards({required this.stats});

  final QuestionStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            number: '${stats.newQuestions}',
            label: 'متبقية',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: AppColors.spacingSmall),
        Expanded(
          child: _StatCard(
            number: '${stats.correctAnswers}',
            label: 'صحيحة',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: AppColors.spacingSmall),
        Expanded(
          child: _StatCard(
            number: '${stats.incorrectAnswers}',
            label: 'خاطئة',
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.stats});

  final QuestionStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: !stats.isMasterMode
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'احصل على دقة 100% لفتح الوسام! 🏆',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: stats.isMasterMode
              ? AppColors.success.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: stats.isMasterMode
                ? AppColors.success
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Icon(
          stats.isMasterMode ? Icons.emoji_events : Icons.lock_outline,
          size: 32,
          color: stats.isMasterMode
              ? AppColors.golden
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _CircularIndicator extends StatelessWidget {
  const _CircularIndicator({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${value.toStringAsFixed(0)}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.number,
    required this.label,
    required this.isPrimary,
  });

  final String number;
  final String label;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = isPrimary
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.secondaryContainer;
    final borderColor = isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;
    final textColor = isPrimary
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppColors.spacingMedium,
        horizontal: AppColors.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
