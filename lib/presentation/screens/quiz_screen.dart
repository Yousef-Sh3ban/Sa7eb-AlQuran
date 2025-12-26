import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../data/data_sources/local/database.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/repositories/saved_questions_repository.dart';
import '../view_models/quiz_view_model.dart';
import '../widgets/quiz_progress_indicator.dart';
import '../widgets/question_category_badge.dart';
import '../widgets/answer_button.dart';
import '../widgets/confetti_overlay.dart';
import '../widgets/quiz_report_dialog.dart';
import '../widgets/quiz_result_view.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/sound_service.dart';
import '../../core/services/app_settings_service.dart';
import '../../core/utils/rate_limiter.dart';
import '../../core/utils/url_utils.dart';

/// Quiz screen for answering questions
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    required this.surahId,
    this.retryMode = false,
    this.mixMode = false,
    super.key,
  });

  final int surahId;
  final bool retryMode;
  final bool mixMode;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizViewModel _viewModel;
  late final ConfettiController _confettiController;
  late final RateLimiter _answerRateLimiter;

  final _hapticService = HapticService.instance;
  final _soundService = SoundService.instance;
  final _settingsService = AppSettingsService.instance;

  double _fontSize = 1.0;

  @override
  void initState() {
    super.initState();
    final database = AppDatabase();
    _viewModel = QuizViewModel(
      surahId: widget.surahId,
      retryMode: widget.retryMode,
      mixMode: widget.mixMode,
      questionRepo: QuestionRepository(database),
      progressRepo: UserProgressRepository(database),
      savedQuestionsRepo: SavedQuestionsRepository(database),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _answerRateLimiter = RateLimiter(
      throttleDuration: const Duration(milliseconds: 500),
    );

    _loadSettings();
    _viewModel.loadQuestions();
    _viewModel.addListener(_onViewModelChanged);
  }

  Future<void> _loadSettings() async {
    await _settingsService.init();
    setState(() {
      _fontSize = _settingsService.getFontSize();
      _soundService.setEnabled(_settingsService.getSoundEnabled());
    });
  }

  void _onViewModelChanged() {
    setState(() {});

    // احتفال عند إكمال الاختبار بنجاح
    if (_viewModel.isQuizComplete) {
      final accuracy =
          (_viewModel.correctCount / _viewModel.totalQuestions * 100).toInt();
      if (accuracy >= 70) {
        _confettiController.play();
        _hapticService.celebration();
        _soundService.playCelebration();
      }
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _saveQuestion() async {
    try {
      _hapticService.light();
      final wasSaved = _viewModel.isQuestionSaved;
      await _viewModel.toggleSaveQuestion();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                wasSaved ? Icons.bookmark_remove : Icons.bookmark,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  wasSaved ? 'تم إلغاء حفظ السؤال' : 'تم حفظ السؤال بنجاح ✓',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: wasSaved
              ? Colors.orange.shade700
              : Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }

  void _reportQuestion() {
    showDialog(
      context: context,
      builder: (context) => QuizReportDialog(
        onSubmit: ({required issueType, required description}) => _viewModel
            .sendReport(issueType: issueType, description: description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      controller: _confettiController,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: Text(widget.retryMode ? 'مراجعة الأخطاء' : 'الاختبار'),
          actions: [
            if (!_viewModel.isLoading && !_viewModel.isQuizComplete)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    '${_viewModel.currentIndex + 1}/${_viewModel.totalQuestions}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('العودة'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.isQuizComplete) {
      return QuizResultView(
        correctCount: _viewModel.correctCount,
        totalQuestions: _viewModel.totalQuestions,
        onRetry: () {
          _viewModel.reset();
          _viewModel.loadQuestions();
        },
        onResetProgress: _viewModel.resetProgress,
      );
    }

    return _buildQuestionScreen();
  }

  Widget _buildQuestionScreen() {
    final question = _viewModel.currentQuestion!;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      ),
      child: SingleChildScrollView(
        key: ValueKey('q_${question.id}'),
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QuizProgressIndicator(
              currentIndex: _viewModel.currentIndex,
              totalQuestions: _viewModel.totalQuestions,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                QuestionCategoryBadge(category: question.category),
                const Spacer(),
                IconButton(
                  onPressed: _saveQuestion,
                  icon: Icon(
                    _viewModel.isQuestionSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                  ),
                  tooltip: _viewModel.isQuestionSaved
                      ? 'إلغاء الحفظ'
                      : 'حفظ السؤال',
                  iconSize: 24,
                  color: _viewModel.isQuestionSaved
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                IconButton(
                  onPressed: _reportQuestion,
                  icon: const Icon(Icons.flag_outlined),
                  tooltip: 'التبليغ عن السؤال',
                  iconSize: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize:
                    Theme.of(context).textTheme.headlineSmall!.fontSize! *
                    _fontSize,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(question.options.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AnswerButton(
                  text: question.options[index],
                  index: index,
                  isSelected: _viewModel.selectedAnswerIndex == index,
                  isCorrect: index == question.correctAnswerIndex,
                  isAnswered: _viewModel.isAnswered,
                  fontSize: _fontSize,
                  onPressed: () {
                    if (!_answerRateLimiter.canProceed()) return;

                    _viewModel.selectAnswer(index);

                    final isCorrect = index == question.correctAnswerIndex;
                    if (isCorrect) {
                      _soundService.playSuccess();
                    } else {
                      _soundService.playError();
                      _hapticService.error();
                    }
                  },
                ),
              );
            }),
            _buildAnswerFeedback(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerFeedback(dynamic question) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _viewModel.isAnswered
          ? Column(
              key: ValueKey('answer_${_viewModel.currentIndex}'),
              children: [
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _viewModel.selectedAnswerIndex ==
                                      question.correctAnswerIndex
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  _viewModel.selectedAnswerIndex ==
                                      question.correctAnswerIndex
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _viewModel.selectedAnswerIndex ==
                                      question.correctAnswerIndex
                                  ? 'إجابة صحيحة!'
                                  : 'إجابة خاطئة',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        _viewModel.selectedAnswerIndex ==
                                            question.correctAnswerIndex
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (question.explanation.isNotEmpty)
                          InkWell(
                            onTap: () => launchExternalUrl(
                              context,
                              question.explanation,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.link,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    question.explanation,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _viewModel.nextQuestion,
                  child: const Text('السؤال التالي'),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
