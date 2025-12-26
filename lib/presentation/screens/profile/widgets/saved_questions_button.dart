import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class SavedQuestionsButton extends StatelessWidget {
  const SavedQuestionsButton({
    super.key,
    required this.theme,
    required this.onTap,
  });

  final ThemeData theme;
  final VoidCallback onTap;

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
            child: Icon(Icons.bookmark, color: theme.colorScheme.secondary),
          ),
          const SizedBox(width: AppColors.spacingLarge),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأسئلة المحفوظة',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'راجع الأسئلة التي حفظتها',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.arrow_back),
            label: const Text('عرض'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppColors.spacingLarge,
                vertical: AppColors.spacingSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
