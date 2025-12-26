import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class WeeklyActivitySection extends StatelessWidget {
  const WeeklyActivitySection({
    super.key,
    required this.theme,
    required this.weeklyActivity,
    required this.maxWeeklyActivity,
  });

  final ThemeData theme;
  final List<int> weeklyActivity;
  final int maxWeeklyActivity;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'النشاط الأسبوعي',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'الأفضل: $maxWeeklyActivity',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppColors.spacingLarge),
          _BarChart(weeklyActivity: weeklyActivity, maxWeeklyActivity: maxWeeklyActivity, theme: theme),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.weeklyActivity, required this.maxWeeklyActivity, required this.theme});

  final List<int> weeklyActivity;
  final int maxWeeklyActivity;
  final ThemeData theme;
  static const List<String> _days = ['س', 'ح', 'ن', 'ث', 'ر', 'خ', 'ج'];

  @override
  Widget build(BuildContext context) {
    final maxValue = maxWeeklyActivity == 0 ? 1 : maxWeeklyActivity;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_days.length, (index) {
        final value = index < weeklyActivity.length ? weeklyActivity[index] : 0;
        final percentage = (value / maxValue).clamp(0.0, 1.0);

        return Column(
          children: [
            Container(
              height: 120,
              width: 22,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppColors.radiusLarge),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  height: 120 * percentage,
                  width: 22,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppColors.radiusLarge),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppColors.spacingSmall),
            Text(
              _days[index],
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      }),
    );
  }
}
