import 'package:flutter/material.dart';
import '../../domain/entities/question_category.dart';
import '../../core/themes/question_category_colors.dart';

/// Badge widget for displaying question category
class QuestionCategoryBadge extends StatelessWidget {
  const QuestionCategoryBadge({required this.category, super.key});

  final QuestionCategory category;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<QuestionCategoryColors>()!;
    final categoryColor = _getCategoryColor(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.displayName,
            style: TextStyle(
              color: categoryColor,
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
