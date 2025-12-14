import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'question_category_colors.dart';
import 'app_colors.dart';
import 'color_schemes.dart' as app_schemes;

/// Application theme configuration.
///
/// Provides light and dark themes with Material 3 design,
/// custom Arabic fonts, and question category colors.
class AppTheme {
  AppTheme._();

  /// Light theme configuration with custom color scheme
  static ThemeData lightTheme([app_schemes.ColorScheme? scheme]) {
    final selectedScheme = scheme ?? app_schemes.ColorSchemes.islamicGreen;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: selectedScheme.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      extensions: const <ThemeExtension<dynamic>>[
        QuestionCategoryColors.light,
      ],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: AppColors.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppColors.radiusLarge)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.notoKufiArabic(
              fontSize: AppColors.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            );
          }
          return GoogleFonts.notoKufiArabic(
            fontSize: AppColors.fontSizeBody,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
    );
  }

  /// Dark theme configuration with custom color scheme
  static ThemeData darkTheme([app_schemes.ColorScheme? scheme]) {
    final selectedScheme = scheme ?? app_schemes.ColorSchemes.islamicGreen;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: selectedScheme.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
      extensions: const <ThemeExtension<dynamic>>[
        QuestionCategoryColors.dark,
      ],
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: AppColors.elevationLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppColors.radiusLarge)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.notoKufiArabic(
              fontSize: AppColors.fontSizeBody,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            );
          }
          return GoogleFonts.notoKufiArabic(
            fontSize: AppColors.fontSizeBody,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
    );
  }

  /// Build text theme with Arabic font (notoKufiArabic)
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return GoogleFonts.notoKufiArabicTextTheme(
      ThemeData(brightness: colorScheme.brightness).textTheme,
    ).copyWith(
      displayLarge: GoogleFonts.notoKufiArabic(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displayMedium: GoogleFonts.notoKufiArabic(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
      displaySmall: GoogleFonts.notoKufiArabic(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineLarge: GoogleFonts.notoKufiArabic(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineMedium: GoogleFonts.notoKufiArabic(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      headlineSmall: GoogleFonts.notoKufiArabic(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleLarge: GoogleFonts.notoKufiArabic(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.notoKufiArabic(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.notoKufiArabic(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
      bodyLarge: GoogleFonts.notoKufiArabic(
        fontSize: 20,
        height: 1.8,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.notoKufiArabic(
        fontSize: 16,
        height: 1.6,
        color: colorScheme.onSurface,
      ),
      bodySmall: GoogleFonts.notoKufiArabic(
        fontSize: 14,
        height: 1.5,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.notoKufiArabic(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
      ),
      labelMedium: GoogleFonts.notoKufiArabic(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.notoKufiArabic(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
