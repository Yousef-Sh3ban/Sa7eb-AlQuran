import '../models/user_progress_model.dart';
import '../data_sources/local/database.dart';

/// Repository for managing user progress data
class UserProgressRepository {
  UserProgressRepository(this._database);

  final AppDatabase _database;

  /// Get progress for a specific question
  Future<UserProgressModel?> getProgress(String questionId) async {
    final UserProgressData? progress = await _database.getProgress(questionId);
    return progress != null ? _mapToModel(progress) : null;
  }

  /// Get progress for multiple questions in a single query (efficient)
  Future<Map<String, UserProgressModel>> getProgressBatch(
    List<String> questionIds,
  ) async {
    final progressList = await _database.getProgressBatch(questionIds);
    return Map.fromEntries(
      progressList.map((p) => MapEntry(p.questionId, _mapToModel(p))),
    );
  }

  /// Update progress for a question
  Future<void> updateProgress(UserProgressModel progress) async {
    await _database.upsertProgress(
      progress.questionId,
      progress.status,
      progress.attempts,
    );
  }

  /// Get all incorrect questions for a surah
  Future<List<String>> getIncorrectQuestionIds(int surahId) async {
    final List<UserProgressData> incorrectProgress = await (_database.select(
      _database.userProgress,
    )..where((p) => p.status.equals(1))).get();
    return incorrectProgress.map((p) => p.questionId).toList();
  }

  /// Get statistics for a surah
  Future<({int total, int attempts, int correct})> getSurahStats(
    int surahId,
    List<String> questionIds,
  ) async {
    int attempts = 0;
    int correct = 0;

    for (final String questionId in questionIds) {
      final UserProgressData? progress = await _database.getProgress(
        questionId,
      );
      if (progress != null) {
        attempts++;
        if (progress.status == 2) {
          correct++;
        }
      }
    }

    return (total: questionIds.length, attempts: attempts, correct: correct);
  }

  /// Get overall statistics across all questions
  Future<Map<String, int>> getOverallStats() async {
    final allProgress = await _database.select(_database.userProgress).get();

    int totalQuestions = 0;
    int answeredQuestions = allProgress.length;
    int correctAnswers = 0;

    for (final progress in allProgress) {
      if (progress.status == 2) {
        correctAnswers++;
      }
    }

    // Get total questions count from questions table
    final questionsCount = await _database.select(_database.questions).get();
    totalQuestions = questionsCount.length;

    return {
      'totalQuestions': totalQuestions,
      'answeredQuestions': answeredQuestions,
      'correctAnswers': correctAnswers,
    };
  }

  /// Get completion percentage for a specific surah
  Future<double> getSurahCompletionPercentage(int surahId) async {
    // Get all questions for this surah
    final questions = await (_database.select(
      _database.questions,
    )..where((q) => q.surahId.equals(surahId))).get();

    if (questions.isEmpty) return 0.0;

    int answeredCount = 0;
    for (final question in questions) {
      final progress = await _database.getProgress(question.id);
      if (progress != null && progress.attempts > 0) {
        answeredCount++;
      }
    }

    return (answeredCount / questions.length) * 100;
  }

  /// Map database UserProgressData to UserProgressModel
  UserProgressModel _mapToModel(UserProgressData data) {
    return UserProgressModel(
      questionId: data.questionId,
      status: data.status,
      attempts: data.attempts,
      lastAttempt: data.lastAttempt,
    );
  }

  /// Reset progress for all questions in a specific surah
  Future<void> resetSurahProgress(int surahId) async {
    // Get all questions for this surah
    final questions = await (_database.select(
      _database.questions,
    )..where((q) => q.surahId.equals(surahId))).get();

    // Delete progress for each question
    for (final question in questions) {
      await (_database.delete(
        _database.userProgress,
      )..where((p) => p.questionId.equals(question.id))).go();
    }
  }
}
