import 'dart:async';

/// Rate Limiter لمنع الضغط السريع على الأزرار
class RateLimiter {
  DateTime? _lastActionTime;
  final Duration throttleDuration;

  RateLimiter({
    this.throttleDuration = const Duration(milliseconds: 500),
  });

  /// التحقق من إمكانية تنفيذ الإجراء
  bool canProceed() {
    final now = DateTime.now();

    if (_lastActionTime == null) {
      _lastActionTime = now;
      return true;
    }

    final timeSinceLastAction = now.difference(_lastActionTime!);

    if (timeSinceLastAction >= throttleDuration) {
      _lastActionTime = now;
      return true;
    }

    return false;
  }

  /// تنفيذ دالة مع rate limiting
  Future<void> execute(Future<void> Function() action) async {
    if (canProceed()) {
      await action();
    }
  }

  /// تنفيذ دالة مع rate limiting وإرجاع قيمة
  Future<T?> executeWithResult<T>(Future<T> Function() action) async {
    if (canProceed()) {
      return await action();
    }
    return null;
  }

  /// إعادة تعيين الـ limiter
  void reset() {
    _lastActionTime = null;
  }
}
