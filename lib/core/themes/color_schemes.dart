import 'package:flutter/material.dart';

/// مخططات الألوان المختلفة للتطبيق
class ColorSchemes {
  ColorSchemes._();

  // ========== 6 مخططات ألوان ==========

  /// 1. الأخضر الإسلامي (الافتراضي)
  static const ColorScheme islamicGreen = ColorScheme(
    primary: Color(0xFF2E7D32),
    secondary: Color(0xFF388E3C),
    name: 'الأخضر الإسلامي',
  );

  /// 2. الأزرق الهادئ
  static const ColorScheme calmBlue = ColorScheme(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF42A5F5),
    name: 'الأزرق الهادئ',
  );

  /// 3. البنفسجي الروحاني
  static const ColorScheme spiritualPurple = ColorScheme(
    primary: Color(0xFF6A1B9A),
    secondary: Color(0xFF9C27B0),
    name: 'البنفسجي الروحاني',
  );

  /// 4. البرتقالي الدافئ
  static const ColorScheme warmOrange = ColorScheme(
    primary: Color(0xFFE65100),
    secondary: Color(0xFFFF6F00),
    name: 'البرتقالي الدافئ',
  );

  /// 5. البني الطبيعي
  static const ColorScheme naturalBrown = ColorScheme(
    primary: Color(0xFF5D4037),
    secondary: Color(0xFF795548),
    name: 'البني الطبيعي',
  );

  /// 6. الأزرق الداكن الأنيق
  static const ColorScheme elegantDarkBlue = ColorScheme(
    primary: Color(0xFF0D47A1),
    secondary: Color(0xFF1565C0),
    name: 'الأزرق الداكن',
  );

  /// قائمة جميع المخططات
  static const List<ColorScheme> allSchemes = [
    islamicGreen,
    calmBlue,
    spiritualPurple,
    warmOrange,
    naturalBrown,
    elegantDarkBlue,
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
