import 'package:flutter/material.dart';
import '../../domain/entities/question_category.dart';
import '../../core/themes/question_category_colors.dart';

/// Badge widget for displaying question category
class QuestionCategoryBadge extends StatelessWidget {
  const QuestionCategoryBadge({
    required this.category,
    super.key,
  });

  final QuestionCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<QuestionCategoryColors>()!;
    final categoryColor = _getCategoryColor(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: categoryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.icon,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            category.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(QuestionCategoryColors colors) {
    return switch (category) {
      QuestionCategory.hifz => colors.hifzColor,
      QuestionCategory.tajweed => colors.tajweedColor,
      QuestionCategory.tafseer => colors.tafseerColor,
      QuestionCategory.general => colors.generalColor,
    };
  }
}
