import 'package:flutter/material.dart';
import '../../data/models/surah_model.dart';

/// Enhanced Surah card with circular progress and star
class SurahCard extends StatelessWidget {
  final SurahModel surah;
  final double completionPercentage;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.surah,
    required this.completionPercentage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = completionPercentage >= 100;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Surah Number
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '${surah.orderNumber}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Surah Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.nameArabic,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SurahNameMadina',
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          surah.revelationType,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          "-",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'آية ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        Text(
                          '${surah.totalAyahs}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Circular Progress Indicator with Star
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Circular Progress (Filled)
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: CircularProgressIndicator(
                        value: completionPercentage / 100,
                        strokeWidth: 6,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted
                              ? Colors.green
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Percentage Text
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withValues(alpha: 0.15)
                            : theme.colorScheme.primaryContainer.withValues(
                                alpha: 0.3,
                              ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${completionPercentage.toStringAsFixed(0)}%',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    // Star for 100% completion
                    if (isCompleted)
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.6),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
