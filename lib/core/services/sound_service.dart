import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

/// خدمة المؤثرات الصوتية
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  final AudioPlayer _player = AudioPlayer();
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
      // استخدام صوت من URL مباشر للتوافق مع جميع المنصات
      await _player.play(UrlSource(
        'https://actions.google.com/sounds/v1/alarms/beep_short.ogg',
      ));
      // يمكن استبداله بملف صوتي مخصص:
      // await _player.play(AssetSource('sounds/success.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// تشغيل صوت الإجابة الخاطئة
  Future<void> playError() async {
    if (!_isEnabled) return;

    try {
      await _player.play(UrlSource(
        'https://actions.google.com/sounds/v1/alarms/digital_watch_alarm_long.ogg',
      ));
      // يمكن استبداله بملف صوتي مخصص:
      // await _player.play(AssetSource('sounds/error.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  /// تشغيل صوت احتفالي
  Future<void> playCelebration() async {
    if (!_isEnabled) return;

    try {
      await _player.play(UrlSource(
        'https://actions.google.com/sounds/v1/cartoon/cartoon_boing.ogg',
      ));
      // يمكن استبداله بملف صوتي مخصص:
      // await _player.play(AssetSource('sounds/celebration.mp3'));
    } catch (e) {
      // Fallback to system sound
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// تشغيل صوت النقر
  Future<void> playTap() async {
    if (!_isEnabled) return;

    try {
      await _player.play(UrlSource(
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
      await _player.stop();
    } catch (e) {
      // تجاهل الأخطاء
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _player.dispose();
  }
}
