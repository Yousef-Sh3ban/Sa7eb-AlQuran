import 'package:flutter/foundation.dart';
import '../../data/models/question_model.dart';
import '../../data/models/user_progress_model.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../domain/use_cases/fetch_questions_usecase.dart';
import '../../core/constants/app_constants.dart';

/// ViewModel for Quiz screen
class QuizViewModel extends ChangeNotifier {
  QuizViewModel({
    required this.surahId,
    required this.retryMode,
    this.mixMode = false,
    required QuestionRepository questionRepo,
    required UserProgressRepository progressRepo,
  })  : _progressRepo = progressRepo,
        _fetchQuestionsUseCase =
            FetchQuestionsUseCase(questionRepo, progressRepo);

  final int surahId;
  final bool retryMode;
  final bool mixMode;
  final UserProgressRepository _progressRepo;
  final FetchQuestionsUseCase _fetchQuestionsUseCase;

  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswered = false;
  int _correctCount = 0;
  bool _isLoading = false;
  String? _errorMessage;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  bool get isAnswered => _isAnswered;
  int get correctCount => _correctCount;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isQuizComplete => _currentIndex >= _questions.length;

  QuestionModel? get currentQuestion =>
      _currentIndex < _questions.length ? _questions[_currentIndex] : null;

  int get totalQuestions => _questions.length;
  int get progressPercentage =>
      _questions.isEmpty ? 0 : ((_currentIndex / _questions.length) * 100).toInt();

  /// Load questions for the quiz
  Future<void> loadQuestions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _questions = await _fetchQuestionsUseCase.execute(
        surahId: surahId,
        limit: AppConstants.questionsPerSession,
        retryMode: retryMode,
        mixMode: mixMode,
      );

      if (_questions.isEmpty) {
        if (retryMode) {
          _errorMessage = 'لا توجد أخطاء متبقية - أحسنت!';
        } else {
          _errorMessage = 'لا توجد أسئلة متاحة حالياً';
        }
      }
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء تحميل الأسئلة';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select an answer
  void selectAnswer(int answerIndex) {
    if (_isAnswered) return;

    _selectedAnswerIndex = answerIndex;
    _isAnswered = true;

    final QuestionModel question = currentQuestion!;
    final bool isCorrect = answerIndex == question.correctAnswerIndex;

    if (isCorrect) {
      _correctCount++;
    }

    _saveProgress(isCorrect);
    notifyListeners();
  }

  /// Save progress to database
  Future<void> _saveProgress(bool isCorrect) async {
    final QuestionModel question = currentQuestion!;
    final UserProgressModel? existingProgress =
        await _progressRepo.getProgress(question.id);

    final int newStatus = isCorrect ? 2 : 1;
    final int newAttempts = (existingProgress?.attempts ?? 0) + 1;

    await _progressRepo.updateProgress(
      UserProgressModel(
        questionId: question.id,
        status: newStatus,
        attempts: newAttempts,
        lastAttempt: DateTime.now(),
      ),
    );
    
    // تحديث نشاط اليوم في الملف الشخصي
    final UserProfileRepository profileRepo = UserProfileRepository();
    await profileRepo.markTodayActive();
  }

  /// Move to next question
  void nextQuestion() {
    if (!_isAnswered) return;

    _currentIndex++;
    _selectedAnswerIndex = null;
    _isAnswered = false;
    notifyListeners();
  }

  /// Reset quiz
  void reset() {
    _currentIndex = 0;
    _selectedAnswerIndex = null;
    _isAnswered = false;
    _correctCount = 0;
    notifyListeners();
  }
}
