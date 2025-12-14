import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// خدمة الاهتزازات (Haptic Feedback)
class HapticService {
  HapticService._();

  static final HapticService instance = HapticService._();

  /// التحقق من دعم الجهاز للاهتزازات
  Future<bool> hasVibrator() async {
    try {
      return await Vibration.hasVibrator();
    } catch (e) {
      return false;
    }
  }

  /// اهتزاز خفيف (للإجابة الصحيحة)
  Future<void> success() async {
    if (await hasVibrator()) {
      // اهتزاز قصير لطيف
      await Vibration.vibrate(duration: 100);
    } else {
      // Fallback للأجهزة التي لا تدعم vibration package
      HapticFeedback.mediumImpact();
    }
  }

  /// اهتزاز متوسط (للإجابة الخاطئة)
  Future<void> error() async {
    if (await hasVibrator()) {
      // اهتزاز مزدوج للخطأ
      await Vibration.vibrate(duration: 50);
      await Future.delayed(const Duration(milliseconds: 100));
      await Vibration.vibrate(duration: 50);
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  /// اهتزاز احتفالي (عند إكمال السورة)
  Future<void> celebration() async {
    if (await hasVibrator()) {
      // نمط احتفالي
      await Vibration.vibrate(
        pattern: [0, 100, 50, 100, 50, 200],
      );
    } else {
      HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 100));
      HapticFeedback.heavyImpact();
    }
  }

  /// اهتزاز خفيف للتفاعلات العامة
  void light() {
    HapticFeedback.lightImpact();
  }

  /// اهتزاز متوسط للتفاعلات
  void medium() {
    HapticFeedback.mediumImpact();
  }

  /// اهتزاز قوي للتفاعلات
  void heavy() {
    HapticFeedback.heavyImpact();
  }

  /// اهتزاز للاختيار
  void selection() {
    HapticFeedback.selectionClick();
  }
}
