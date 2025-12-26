/// Application configuration for sensitive data and feature flags.
///
/// For production, these values should be overridden using
/// `--dart-define` flags during build. Example:
/// ```
/// flutter build apk --dart-define=TELEGRAM_BOT_TOKEN=your_token
/// ```
abstract final class AppConfig {
  /// Telegram Bot Token (override with --dart-define=TELEGRAM_BOT_TOKEN=...)
  static const String telegramBotToken = String.fromEnvironment(
    'TELEGRAM_BOT_TOKEN',
    defaultValue: '',
  );

  /// Telegram Chat ID for reports (override with --dart-define=TELEGRAM_CHAT_ID=...)
  static const String telegramChatId = String.fromEnvironment(
    'TELEGRAM_CHAT_ID',
    defaultValue: '',
  );

  /// Checks if Telegram reporting is configured.
  static bool get isTelegramConfigured =>
      telegramBotToken.isNotEmpty && telegramChatId.isNotEmpty;
}
