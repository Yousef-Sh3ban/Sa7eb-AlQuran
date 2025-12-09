/// Application-wide constants.
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'صاحب القرآن';
  static const String appVersion = '1.0.0';

  // GitHub Data Source
  static const String githubRawBaseUrl =
      'https://raw.githubusercontent.com/username/repo/main/data';
  static const String questionsJsonUrl = '$githubRawBaseUrl/questions_v1.json';
  static const String versionJsonUrl = '$githubRawBaseUrl/version.json';

  // Local Storage Keys
  static const String keyContentVersion = 'content_version';
  static const String keyTotalQuestionsAnswered = 'total_answered';
  static const String keyIsGuestMode = 'is_guest_mode';

  // Quiz Settings
  static const int questionsPerSession = 10;
  static const int signUpPromptThreshold = 50;

  // Database
  static const String databaseName = 'sa7eb_alquran.db';
  static const int databaseVersion = 1;
}
