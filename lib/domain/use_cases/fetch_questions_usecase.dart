import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/models/question_model.dart';

/// Use case for fetching questions with smart algorithm
class FetchQuestionsUseCase {
  FetchQuestionsUseCase(this._questionRepo, this._progressRepo);

  final QuestionRepository _questionRepo;
  final UserProgressRepository _progressRepo;

  /// Fetch questions with priority:
  /// Priority 1: Incorrect questions (status = 1)
  /// Priority 2: New questions (not in progress table)
  /// Exclude: Correct questions (status = 2) unless mixMode = true
  /// retryMode: Only incorrect questions
  Future<List<QuestionModel>> execute({
    required int surahId,
    required int limit,
    bool retryMode = false,
    bool mixMode = false,
  }) async {
    final List<QuestionModel> allQuestions =
        await _questionRepo.getQuestionsBySurah(surahId);

    // Mix Mode: جميع الأسئلة عشوائياً (للمراجعة)
    if (mixMode) {
      final shuffled = List<QuestionModel>.from(allQuestions);
      shuffled.shuffle();
      return shuffled.take(limit).toList();
    }

    // Fetch all progress in a single batch query (fixed N+1 problem)
    final questionIds = allQuestions.map((q) => q.id).toList();
    final progressMap = await _progressRepo.getProgressBatch(questionIds);

    // Retry Mode: فقط الأسئلة الخاطئة
    if (retryMode) {
      final List<QuestionModel> incorrectQuestions = [];
      
      for (final QuestionModel question in allQuestions) {
        final progress = progressMap[question.id];
        if (progress != null && progress.status == 1) {
          incorrectQuestions.add(question);
        }
      }
      
      return incorrectQuestions.take(limit).toList();
    }

    // Normal Mode: أسئلة جديدة أولاً ثم الخاطئة
    final List<QuestionModel> priorityQuestions = [];
    final List<QuestionModel> newQuestions = [];

    for (final QuestionModel question in allQuestions) {
      final progress = progressMap[question.id];

      if (progress == null) {
        newQuestions.add(question);
      } else if (progress.status == 1) {
        priorityQuestions.add(question);
      }
    }

    final List<QuestionModel> result = [
      ...priorityQuestions,
      ...newQuestions,
    ];

    return result.take(limit).toList();
  }
}
