/// Question category enumeration.
///
/// Represents different types of Quranic questions:
/// - [hifz]: Memorization questions (حفظ)
/// - [tajweed]: Recitation rules questions (تجويد)
/// - [tafseer]: Interpretation questions (تفسير)
/// - [general]: General knowledge questions (عام)
enum QuestionCategory {
  hifz,
  tajweed,
  tafseer,
  general;

  /// Returns the Arabic display name for the category.
  String get displayName {
    switch (this) {
      case QuestionCategory.hifz:
        return 'حفظ';
      case QuestionCategory.tajweed:
        return 'تجويد';
      case QuestionCategory.tafseer:
        return 'تفسير';
      case QuestionCategory.general:
        return 'عام';
    }
  }

  /// Returns the category icon.
  String get icon {
    switch (this) {
      case QuestionCategory.hifz:
        return '📖';
      case QuestionCategory.tajweed:
        return '🎵';
      case QuestionCategory.tafseer:
        return '💡';
      case QuestionCategory.general:
        return '📚';
    }
  }

  /// Creates a category from a string value.
  static QuestionCategory fromString(String value) {
    return QuestionCategory.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => QuestionCategory.general,
    );
  }
}
