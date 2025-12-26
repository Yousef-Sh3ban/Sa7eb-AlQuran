import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.theme,
    required this.userName,
    required this.userTitle,
    required this.userImage,
    required this.dayStreak,
    required this.answeredQuestions,
    required this.accuracy,
    required this.onEditName,
    required this.onPickImage,
    required this.onShowTitleRules,
  });

  final ThemeData theme;
  final String userName;
  final String userTitle;
  final File? userImage;
  final int dayStreak;
  final int answeredQuestions;
  final double accuracy;
  final VoidCallback onEditName;
  final VoidCallback onPickImage;
  final VoidCallback onShowTitleRules;

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:isDark
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
        top: AppColors.spacingXXLarge * 2,
        bottom: AppColors.spacingXXLarge,
        left: AppColors.spacingLarge,
        right: AppColors.spacingLarge,
      ),
      child: Column(
        children: [
          _Avatar(userImage: userImage, onPickImage: onPickImage, theme: theme),
          const SizedBox(height: AppColors.spacingLarge),
          _EditableName(userName: userName, onEditName: onEditName, theme: theme),
          const SizedBox(height: AppColors.spacingSmall),
          _TitleRow(userTitle: userTitle, onShowTitleRules: onShowTitleRules, theme: theme),
          const SizedBox(height: AppColors.spacingXXLarge),
          _QuickStats(
            theme: theme,
            dayStreak: dayStreak,
            answeredQuestions: answeredQuestions,
            accuracy: accuracy,
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.userImage, required this.onPickImage, required this.theme});

  final File? userImage;
  final VoidCallback onPickImage;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: userImage != null ? FileImage(userImage!) : null,
            child: userImage == null
                ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: onPickImage,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditableName extends StatelessWidget {
  const _EditableName({required this.userName, required this.onEditName, required this.theme});

  final String userName;
  final VoidCallback onEditName;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onEditName,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            userName,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: AppColors.spacingSmall),
          const Icon(Icons.edit, size: 20, color: Colors.white),
        ],
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  const _TitleRow({required this.userTitle, required this.onShowTitleRules, required this.theme});

  final String userTitle;
  final VoidCallback onShowTitleRules;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onShowTitleRules,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            userTitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(width: AppColors.spacingSmall),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.info, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({
    required this.theme,
    required this.dayStreak,
    required this.answeredQuestions,
    required this.accuracy,
  });

  final ThemeData theme;
  final int dayStreak;
  final int answeredQuestions;
  final double accuracy;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickStatCard(
          theme: theme,
          icon: Icons.local_fire_department,
          label: 'أيام متتالية',
          value: dayStreak.toString(),
          color: Colors.orange,
        ),
        _QuickStatCard(
          theme: theme,
          icon: Icons.quiz,
          label: 'الأسئلة',
          value: answeredQuestions.toString(),
          color: Colors.blue,
        ),
        _QuickStatCard(
          theme: theme,
          icon: Icons.gps_fixed,
          label: 'الدقة',
          value: '${accuracy.toStringAsFixed(1)}%',
          color: AppColors.getAccuracyColor(accuracy),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
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
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppColors.spacingSmall),
        padding: const EdgeInsets.all(AppColors.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppColors.iconSizeMedium),
            const SizedBox(height: AppColors.spacingSmall),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: AppColors.spacingXSmall),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
