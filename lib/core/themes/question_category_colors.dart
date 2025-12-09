import 'package:flutter/material.dart';

/// Custom theme extension for question category colors.
///
/// Provides color coding for different question types:
/// - Hifz (Memorization): Green
/// - Tajweed (Recitation rules): Purple
/// - Tafseer (Interpretation): Orange
/// - General: Blue
@immutable
class QuestionCategoryColors extends ThemeExtension<QuestionCategoryColors> {
  const QuestionCategoryColors({
    required this.hifzColor,
    required this.tajweedColor,
    required this.tafseerColor,
    required this.generalColor,
  });

  final Color hifzColor;
  final Color tajweedColor;
  final Color tafseerColor;
  final Color generalColor;

  @override
  QuestionCategoryColors copyWith({
    Color? hifzColor,
    Color? tajweedColor,
    Color? tafseerColor,
    Color? generalColor,
  }) {
    return QuestionCategoryColors(
      hifzColor: hifzColor ?? this.hifzColor,
      tajweedColor: tajweedColor ?? this.tajweedColor,
      tafseerColor: tafseerColor ?? this.tafseerColor,
      generalColor: generalColor ?? this.generalColor,
    );
  }

  @override
  QuestionCategoryColors lerp(
    covariant ThemeExtension<QuestionCategoryColors>? other,
    double t,
  ) {
    if (other is! QuestionCategoryColors) {
      return this;
    }
    return QuestionCategoryColors(
      hifzColor: Color.lerp(hifzColor, other.hifzColor, t)!,
      tajweedColor: Color.lerp(tajweedColor, other.tajweedColor, t)!,
      tafseerColor: Color.lerp(tafseerColor, other.tafseerColor, t)!,
      generalColor: Color.lerp(generalColor, other.generalColor, t)!,
    );
  }

  /// Light theme colors
  static const QuestionCategoryColors light = QuestionCategoryColors(
    hifzColor: Color(0xFF2E7D32), // Green 700
    tajweedColor: Color(0xFF6A1B9A), // Purple 800
    tafseerColor: Color(0xFFE65100), // Deep Orange 900
    generalColor: Color(0xFF1565C0), // Blue 800
  );

  /// Dark theme colors
  static const QuestionCategoryColors dark = QuestionCategoryColors(
    hifzColor: Color(0xFF66BB6A), // Green 400
    tajweedColor: Color(0xFFAB47BC), // Purple 400
    tafseerColor: Color(0xFFFF9800), // Orange 500
    generalColor: Color(0xFF42A5F5), // Blue 400
  );
}
