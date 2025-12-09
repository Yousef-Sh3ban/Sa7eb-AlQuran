import 'package:flutter/material.dart';

/// مركزية ألوان التطبيق
/// يمكن تغيير جميع الألوان من هنا بسهولة
class AppColors {
  AppColors._();

  // ========== الألوان الأساسية ==========
  
  /// اللون الأساسي (الأخضر الإسلامي)
  static const Color primaryGreen = Color(0xFF2E7D32);
  
  /// اللون الثانوي
  static const Color secondaryColor = Color(0xFF388E3C);

  // ========== ألوان الدقة (Accuracy) ==========
  
  /// دقة عالية (80% فأكثر)
  static const Color accuracyHigh = Color(0xFF4CAF50); // أخضر
  
  /// دقة متوسطة (50% - 79%)
  static const Color accuracyMedium = Color(0xFFFF9800); // برتقالي
  
  /// دقة منخفضة (أقل من 50%)
  static const Color accuracyLow = Color(0xFFF44336); // أحمر

  // ========== ألوان الحالات ==========
  
  /// لون النجاح
  static const Color success = Color(0xFF4CAF50);
  
  /// لون التحذير
  static const Color warning = Color(0xFFFF9800);
  
  /// لون الخطأ
  static const Color error = Color(0xFFF44336);
  
  /// لون المعلومات
  static const Color info = Color(0xFF2196F3);

  // ========== ألوان Progress ==========
  
  /// بداية Gradient للتقدم
  static const Color progressStart = Color(0xFF2E7D32);
  
  /// نهاية Gradient للتقدم
  static const Color progressEnd = Color(0xFF66BB6A);

  // ========== ألوان الخلفيات ==========
  
  /// خلفية فاتحة
  static const Color lightBackground = Color(0xFFFAFAFA);
  
  /// خلفية داكنة
  static const Color darkBackground = Color(0xFF121212);
  
  /// خلفية الكارت الفاتحة
  static const Color lightCardBackground = Colors.white;
  
  /// خلفية الكارت الداكنة
  static const Color darkCardBackground = Color(0xFF1E1E1E);

  static const Color golden = Color(0Xffffd700);

  // ========== الشفافية ==========
  
  /// شفافية خفيفة (5%)
  static const double opacity5 = 0.05;
  
  /// شفافية متوسطة خفيفة (15%)
  static const double opacity15 = 0.15;
  
  /// شفافية متوسطة (30%)
  static const double opacity30 = 0.30;
  
  /// شفافية متوسطة عالية (60%)
  static const double opacity60 = 0.60;
  
  /// شفافية عالية (70%)
  static const double opacity70 = 0.70;

  // ========== أحجام الخطوط ==========
  
  static const double fontSizeSmall = 10.0;
  static const double fontSizeBody = 12.0;
  static const double fontSizeTitle = 14.0;
  static const double fontSizeHeading = 18.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;

  // ========== أحجام الأيقونات ==========
  
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
  static const double iconSizeXLarge = 40.0;

  // ========== Border Radius ==========
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;

  // ========== Spacing & Padding ==========
  
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingXXLarge = 24.0;

  // ========== Elevation ==========
  
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationXHigh = 12.0;

  // ========== Helper Methods ==========
  
  /// الحصول على لون الدقة حسب النسبة المئوية
  static Color getAccuracyColor(double percentage) {
    if (percentage >= 80) return accuracyHigh;
    if (percentage >= 50) return accuracyMedium;
    return accuracyLow;
  }
  
  /// الحصول على لون مع شفافية
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}
