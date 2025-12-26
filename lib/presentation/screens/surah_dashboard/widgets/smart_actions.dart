import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/stats_calculator.dart';

class SmartActions extends StatelessWidget {
  const SmartActions({
    super.key,
    required this.stats,
    required this.onStartNewQuiz,
    required this.onRetryErrors,
    required this.onStartMixedReview,
  });

  final QuestionStats stats;
  final VoidCallback onStartNewQuiz;
  final VoidCallback onRetryErrors;
  final VoidCallback onStartMixedReview;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (stats.hasNewQuestions) ...[
              _PrimaryButton(
                label: 'تابع التحدي',
                subtitle: 'أسئلة جديدة بانتظارك',
                icon: Icons.rocket_launch,
                onPressed: onStartNewQuiz,
              ),
              const SizedBox(height: AppColors.spacingLarge),
              _SecondaryButton(
                label: 'تصحيح الأخطاء',
                subtitle: stats.hasIncorrectAnswers
                    ? '${stats.incorrectAnswers} خطأ'
                    : 'لا توجد أخطاء',
                icon: Icons.replay,
                onPressed: stats.hasIncorrectAnswers ? onRetryErrors : null,
              ),
            ]
            else if (stats.hasIncorrectAnswers) ...[
              _PrimaryButton(
                label: 'مراجعة وإعادة حل',
                subtitle: 'اختبار عشوائي للتثبيت',
                icon: Icons.shuffle,
                onPressed: onStartMixedReview,
              ),
              const SizedBox(height: AppColors.spacingLarge),
              _SecondaryButton(
                label: 'تصحيح الأخطاء المتبقية',
                subtitle: '${stats.incorrectAnswers} خطأ متبقي',
                icon: Icons.replay,
                onPressed: onRetryErrors,
              ),
            ]
            else if (stats.isMasterMode) ...[
              _MasterButton(
                label: 'مراجعة وإعادة حل',
                subtitle: 'اختبار عشوائي للتثبيت',
                icon: Icons.refresh,
                onPressed: onStartMixedReview,
              ),
              const SizedBox(height: AppColors.spacingMedium),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: AppColors.success, size: 20),
                  const SizedBox(width: AppColors.spacingSmall),
                  Text(
                    'مبارك! أتقنت هذه السورة 🎉',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: AppColors.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back),
        ],
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        side: BorderSide(
          color: onPressed != null
              ? theme.colorScheme.outline
              : theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: AppColors.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back,
            color: onPressed != null
                ? null
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _MasterButton extends StatelessWidget {
  const _MasterButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppColors.spacingLarge),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 32, color: Colors.white),
                const SizedBox(width: AppColors.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_back, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
