import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

/// Overall progress widget showing total completion with modern design
class OverallProgressWidget extends StatelessWidget {
  final double completionPercentage;
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;

  const OverallProgressWidget({
    super.key,
    required this.completionPercentage,
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accuracy = answeredQuestions > 0
        ? (correctAnswers / answeredQuestions * 100)
        : 0.0;

    return Container(
      margin: EdgeInsets.fromLTRB(
        AppColors.spacingLarge,
        AppColors.spacingSmall,
        AppColors.spacingLarge,
        0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.withOpacity(theme.colorScheme.primary, AppColors.opacity15),
            blurRadius: AppColors.elevationXHigh,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.withOpacity(theme.colorScheme.primary, AppColors.opacity5),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.withOpacity(theme.colorScheme.secondary, AppColors.opacity5),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(AppColors.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.emoji_events,
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'التقدم الإجمالي',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$answeredQuestions من $totalQuestions سؤال',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.7),
                                  fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Main Percentage Circle
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${completionPercentage.toStringAsFixed(0)}%',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: completionPercentage / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.secondary,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatBox(
                          // icon:  IconData(SvgPicture.asset('assets/icons/goal.svg')),
                          icon: Icons.gps_fixed,
                          label: 'الدقة',
                          value: '${accuracy.toStringAsFixed(0)}%',
                          color: AppColors.getAccuracyColor(accuracy),
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.quiz,
                          label: 'محلولة',
                          value: '$answeredQuestions',
                          color: theme.colorScheme.primary,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _StatBox(
                          icon: Icons.pending_actions,
                          label: 'متبقية',
                          value: '${totalQuestions - answeredQuestions}',
                          color: theme.colorScheme.secondary,
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatBox({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
