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
  /// Priority 3: Correct questions (status = 2) - only in reviewMode or when others exhausted
  ///
  /// Modes:
  /// - retryMode: Only incorrect questions
  /// - mixMode: All questions shuffled randomly
  /// - reviewMode: All questions including correct ones (for comprehensive review)
  Future<List<QuestionModel>> execute({
    required int surahId,
    required int limit,
    bool retryMode = false,
    bool mixMode = false,
    bool reviewMode = false,
  }) async {
    final List<QuestionModel> allQuestions = await _questionRepo
        .getQuestionsBySurah(surahId);

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

    // Categorize questions
    final List<QuestionModel> incorrectQuestions = [];
    final List<QuestionModel> newQuestions = [];
    final List<QuestionModel> correctQuestions = [];

    for (final QuestionModel question in allQuestions) {
      final progress = progressMap[question.id];

      if (progress == null) {
        newQuestions.add(question);
      } else if (progress.status == 1) {
        incorrectQuestions.add(question);
      } else if (progress.status == 2) {
        correctQuestions.add(question);
      }
    }

    // Review Mode: جميع الأسئلة مع أولوية للخاطئة ثم الجديدة ثم الصحيحة
    if (reviewMode) {
      final List<QuestionModel> result = [
        ...incorrectQuestions,
        ...newQuestions,
        ...correctQuestions,
      ];
      result.shuffle(); // خلط الأنواع معاً
      return result.take(limit).toList();
    }

    // Normal Mode: الأولوية للخاطئة والجديدة، ثم الصحيحة إذا نفدت الأسئلة
    final List<QuestionModel> priorityQuestions = [
      ...incorrectQuestions,
      ...newQuestions,
    ];

    // إذا لم يكن هناك أسئلة جديدة أو خاطئة متبقية، أضف الصحيحة
    if (priorityQuestions.isEmpty) {
      // Shuffle correct questions for variety
      correctQuestions.shuffle();
      return correctQuestions.take(limit).toList();
    }

    // إذا كانت الأسئلة الأولوية أقل من الحد، أضف بعض الصحيحة
    if (priorityQuestions.length < limit && correctQuestions.isNotEmpty) {
      correctQuestions.shuffle();
      final remaining = limit - priorityQuestions.length;
      priorityQuestions.addAll(correctQuestions.take(remaining));
    }

    // خلط الأسئلة لتنويع بين أنواع الأسئلة (تفسير ومعاني)
    priorityQuestions.shuffle();

    return priorityQuestions.take(limit).toList();
  }
}
