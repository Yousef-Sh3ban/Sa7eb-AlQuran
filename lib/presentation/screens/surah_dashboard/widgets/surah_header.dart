import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../data/models/surah_model.dart';

/// رأس صفحة تفاصيل السورة
class SurahHeader extends StatelessWidget {
  const SurahHeader({super.key, required this.surah, required this.onBack});

  final SurahModel surah;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondaryContainer,
                ]
              : [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppColors.radiusXLarge),
          bottomRight: Radius.circular(AppColors.radiusXLarge),
        ),
      ),
      padding: const EdgeInsets.only(
        top: AppColors.spacingXXLarge * 2.5,
        bottom: AppColors.spacingXXLarge,
        left: AppColors.spacingLarge,
        right: AppColors.spacingLarge,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppColors.spacingLarge),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  surah.nameArabic,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SurahNameMadina',
                    fontSize: 70,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppColors.spacingSmall),
          Text(
            surah.nameEnglish,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppColors.spacingXXLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _InfoBadge(
                label: surah.revelationType == 'meccan' ? 'مكية' : 'مدنية',
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _InfoBadge(label: '${surah.totalAyahs} آية'),
              Container(
                width: 1,
                height: 16,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _InfoBadge(label: 'ترتيب ${surah.id}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white.withValues(alpha: 0.95),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
