import 'package:shared_preferences/shared_preferences.dart';

/// خدمة إعدادات التطبيق
class AppSettingsService {
  AppSettingsService._();

  static final AppSettingsService instance = AppSettingsService._();

  // Keys
  static const String _soundEnabledKey = 'sound_enabled';
  static const String _fontSizeKey = 'font_size';

  SharedPreferences? _prefs;

  /// تهيئة الإعدادات
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== Sound Settings ==========

  /// تفعيل/تعطيل الأصوات
  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_soundEnabledKey, enabled);
  }

  /// التحقق من تفعيل الأصوات (افتراضياً: مفعّل)
  bool getSoundEnabled() {
    return _prefs?.getBool(_soundEnabledKey) ?? true;
  }

  // ========== Font Size Settings ==========

  /// تعيين حجم الخط (0.8 - 1.5)
  Future<void> setFontSize(double size) async {
    // التأكد من أن الحجم ضمن النطاق المسموح
    final clampedSize = size.clamp(0.8, 1.5);
    await _prefs?.setDouble(_fontSizeKey, clampedSize);
  }

  /// الحصول على حجم الخط (افتراضياً: 1.0)
  double getFontSize() {
    return _prefs?.getDouble(_fontSizeKey) ?? 1.0;
  }

  /// زيادة حجم الخط
  Future<void> increaseFontSize() async {
    final currentSize = getFontSize();
    if (currentSize < 1.5) {
      await setFontSize(currentSize + 0.1);
    }
  }

  /// تقليل حجم الخط
  Future<void> decreaseFontSize() async {
    final currentSize = getFontSize();
    if (currentSize > 0.8) {
      await setFontSize(currentSize - 0.1);
    }
  }

  /// إعادة تعيين حجم الخط للافتراضي
  Future<void> resetFontSize() async {
    await setFontSize(1.0);
  }

  /// مسح جميع الإعدادات
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
