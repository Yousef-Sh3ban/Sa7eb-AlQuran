import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// خدمة المؤثرات الصوتية
class SoundService {
  SoundService._() {
    // تهيئة المشغلات مع وضع الكمون المنخفض
    _successPlayer.setPlayerMode(PlayerMode.lowLatency);
    _errorPlayer.setPlayerMode(PlayerMode.lowLatency);
    _celebrationPlayer.setPlayerMode(PlayerMode.lowLatency);
    _tapPlayer.setPlayerMode(PlayerMode.lowLatency);
  }

  static final SoundService instance = SoundService._();

  // استخدام مشغلات منفصلة لكل صوت لتجنب التأخير
  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  final AudioPlayer _celebrationPlayer = AudioPlayer();
  final AudioPlayer _tapPlayer = AudioPlayer();
  bool _isEnabled = true;

  /// تفعيل/تعطيل الأصوات
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// التحقق من حالة الأصوات
  bool get isEnabled => _isEnabled;

  /// تشغيل صوت الإجابة الصحيحة
  Future<void> playSuccess() async {
    if (!_isEnabled) return;

    try {
      // إيقاف أي صوت سابق وتشغيل الجديد فوراً
      await _successPlayer.stop();
      await _successPlayer.play(AssetSource('sounds/correct_answer.wav'));
    } catch (e) {
      // Fallback to system sound
      // await SystemSound.play(SystemSoundType.click);
    }
  }

  /// تشغيل صوت الإجابة الخاطئة
  Future<void> playError() async {
    if (!_isEnabled) return;

    try {
      // إيقاف أي صوت سابق وتشغيل الجديد فوراً
      await _errorPlayer.stop();
      await _errorPlayer.play(AssetSource('sounds/wrong_answer.mp3'));
    } catch (e) {
      // Fallback to system sound
      // await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// تشغيل صوت احتفالي
  Future<void> playCelebration() async {
    if (!_isEnabled) return;

    try {
      await _celebrationPlayer.stop();
      await _celebrationPlayer.play(UrlSource(
        'https://actions.google.com/sounds/v1/cartoon/cartoon_boing.ogg',
      ));
      // يمكن استبداله بملف صوتي مخصص:
      // await _celebrationPlayer.play(AssetSource('sounds/celebration.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// تشغيل صوت النقر
  Future<void> playTap() async {
    if (!_isEnabled) return;

    try {
      await _tapPlayer.stop();
      await _tapPlayer.play(UrlSource(
        'https://actions.google.com/sounds/v1/alarms/beep_short.ogg',
      ));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// إيقاف جميع الأصوات
  Future<void> stop() async {
    try {
      await Future.wait([
        _successPlayer.stop(),
        _errorPlayer.stop(),
        _celebrationPlayer.stop(),
        _tapPlayer.stop(),
      ]);
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _successPlayer.dispose();
    _errorPlayer.dispose();
    _celebrationPlayer.dispose();
    _tapPlayer.dispose();
  }
}
