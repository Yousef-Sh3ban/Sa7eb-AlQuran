import 'package:flutter/material.dart';

/// مخططات الألوان المختلفة للتطبيق
class ColorSchemes {
  ColorSchemes._();

  // ========== 9 مخططات ألوان ==========

  /// 1. الأخضر الإسلامي (الافتراضي)
  static const ColorScheme islamicGreen = ColorScheme(
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF66BB6A),
    name: 'الأخضر الإسلامي',
  );

  /// 2. الأزرق السماوي
  static const ColorScheme calmBlue = ColorScheme(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF64B5F6),
    name: 'الأزرق السماوي',
  );

  /// 3. البنفسجي الروحاني
  static const ColorScheme spiritualPurple = ColorScheme(
    primary: Color(0xFF6A1B9A),
    secondary: Color(0xFFAB47BC),
    name: 'البنفسجي الروحاني',
  );

  /// 4. الازرق الأنيق
  static const ColorScheme elegantBlack = ColorScheme(
    primary: Color.fromARGB(255, 99, 37, 255),
    secondary: Color.fromARGB(255, 43, 0, 255),
    name: 'الأزرق  الأنيق ',
  );

  /// 5. البني الترابي
  static const ColorScheme naturalBrown = ColorScheme(
    primary: Color(0xFF3E2723),
    secondary: Color(0xFF6D4C41),
    name: 'البني الترابي',
  );

  /// 6. الأزرق الملكي
  static const ColorScheme elegantDarkBlue = ColorScheme(
    primary: Color(0xFF283593),
    secondary: Color(0xFF5C6BC0),
    name: 'الأزرق الملكي',
  );

  /// 7. الليموني المنعش
  static const ColorScheme freshLime = ColorScheme(
    primary: Color(0xFF9E9D24),
    secondary: Color(0xFFDCE775),
    name: 'الليموني المنعش',
  );

  /// 8. الفيروزي الأنيق
  static const ColorScheme elegantTeal = ColorScheme(
    primary: Color(0xFF00796B),
    secondary: Color(0xFF4DB6AC),
    name: 'الفيروزي الأنيق',
  );

  /// 9. الذهبي الفاخر
  static const ColorScheme luxuryGold = ColorScheme(
    primary: Color(0xFFF57F17),
    secondary: Color(0xFFFFD54F),
    name: 'الذهبي الفاخر',
  );

  /// قائمة جميع المخططات
  static const List<ColorScheme> allSchemes = [
    islamicGreen,
    calmBlue,
    spiritualPurple,
    elegantBlack,
    naturalBrown,
    elegantDarkBlue,
    freshLime,
    elegantTeal,
    luxuryGold,
  ];

  /// الحصول على مخطط حسب الاسم
  static ColorScheme getSchemeByName(String name) {
    return allSchemes.firstWhere(
      (scheme) => scheme.name == name,
      orElse: () => islamicGreen,
    );
  }

  /// الحصول على مخطط حسب الـ index
  static ColorScheme getSchemeByIndex(int index) {
    if (index >= 0 && index < allSchemes.length) {
      return allSchemes[index];
    }
    return islamicGreen;
  }
}

/// مخطط اللون
class ColorScheme {
  final Color primary;
  final Color secondary;
  final String name;

  const ColorScheme({
    required this.primary,
    required this.secondary,
    required this.name,
  });
}
