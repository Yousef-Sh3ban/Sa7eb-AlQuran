import 'package:shared_preferences/shared_preferences.dart';

/// Repository for managing user profile data
class UserProfileRepository {
  static const String _keyUserName = 'user_name';
  static const String _keyUserImage = 'user_image';
  static const String _keyWeekActivity = 'week_activity';
  static const String _keyLastActivityDate = 'last_activity_date';

  /// Get user name
  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? 'طالب العلم';
  }

  /// Set user name
  Future<void> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  /// Get user image path (nullable)
  Future<String?> getUserImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserImage);
  }

  /// Set user image path
  Future<void> setUserImage(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserImage, imagePath);
  }

  /// Get week activity (7 booleans for Mon-Sun)
  Future<List<bool>> getWeekActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final String? activityString = prefs.getString(_keyWeekActivity);
    if (activityString == null) {
      return List.filled(7, false);
    }
    return activityString.split(',').map((e) => e == '1').toList();
  }

  /// Mark today as active
  Future<void> markTodayActive() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final lastDate = prefs.getString(_keyLastActivityDate);
    final today = '${now.year}-${now.month}-${now.day}';

    // Check if already marked today
    if (lastDate == today) return;

    // Get current week activity
    final activity = await getWeekActivity();
    
    // Get current day of week (0 = Monday, 6 = Sunday)
    int dayIndex = now.weekday - 1;
    
    // Mark today as active
    activity[dayIndex] = true;
    
    // Save
    await prefs.setString(_keyWeekActivity, activity.map((e) => e ? '1' : '0').join(','));
    await prefs.setString(_keyLastActivityDate, today);
  }

  /// Reset week activity (called at start of new week)
  Future<void> resetWeekActivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyWeekActivity, List.filled(7, false).map((e) => '0').join(','));
  }

  /// Get user title based on answered questions count
  String getUserTitle(int answeredQuestions) {
    if (answeredQuestions >= 1000) {
      return 'حافظ متقن';
    } else if (answeredQuestions >= 500) {
      return 'حافظ متمكن';
    } else if (answeredQuestions >= 250) {
      return 'حافظ متوسط';
    } else if (answeredQuestions >= 100) {
      return 'حافظ مبتدئ';
    } else if (answeredQuestions >= 50) {
      return 'طالب متحمس';
    } else if (answeredQuestions >= 10) {
      return 'طالب مجتهد';
    } else {
      return 'طالب مبتدئ';
    }
  }

  /// Get title rules for info dialog
  List<Map<String, dynamic>> getTitleRules() {
    return [
      {'from': 0, 'to': 9, 'title': 'طالب مبتدئ'},
      {'from': 10, 'to': 49, 'title': 'طالب مجتهد'},
      {'from': 50, 'to': 99, 'title': 'طالب متحمس'},
      {'from': 100, 'to': 249, 'title': 'حافظ مبتدئ'},
      {'from': 250, 'to': 499, 'title': 'حافظ متوسط'},
      {'from': 500, 'to': 999, 'title': 'حافظ متمكن'},
      {'from': 1000, 'to': null, 'title': 'حافظ متقن'},
    ];
  }
}
