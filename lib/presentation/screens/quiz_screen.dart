import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
import '../../core/services/haptic_service.dart';
import '../../core/services/sound_service.dart';
import '../../core/services/app_settings_service.dart';
import '../../core/utils/rate_limiter.dart';

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
  late final SavedQuestionsRepository _savedQuestionsRepo;
  late final ConfettiController _confettiController;
  late final RateLimiter _answerRateLimiter;
  
  final _hapticService = HapticService.instance;
  final _soundService = SoundService.instance;
  final _settingsService = AppSettingsService.instance;
  
  bool _isQuestionSaved = false;
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
    );
    _savedQuestionsRepo = SavedQuestionsRepository(database);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _answerRateLimiter = RateLimiter(throttleDuration: const Duration(milliseconds: 500));
    
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
    _checkIfQuestionSaved();
    
    // احتفال عند إكمال الاختبار بنجاح
    if (_viewModel.isQuizComplete) {
      final accuracy = (_viewModel.correctCount / _viewModel.totalQuestions * 100).toInt();
      if (accuracy >= 70) {
        _confettiController.play();
        _hapticService.celebration();
        _soundService.playCelebration();
      }
    }
  }

  Future<void> _checkIfQuestionSaved() async {
    if (_viewModel.currentQuestion != null) {
      final saved = await _savedQuestionsRepo
          .isQuestionSaved(_viewModel.currentQuestion!.id);
      if (mounted) {
        setState(() {
          _isQuestionSaved = saved;
        });
      }
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _openLink(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذّر فتح الرابط')),
        );
      }
    }
  }

  Future<void> _saveQuestion() async {
    if (_viewModel.currentQuestion == null) return;

    try {
      _hapticService.light();
      
      if (_isQuestionSaved) {
        await _savedQuestionsRepo
            .unsaveQuestion(_viewModel.currentQuestion!.id);
        setState(() {
          _isQuestionSaved = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إلغاء حفظ السؤال')),
          );
        }
      } else {
        await _savedQuestionsRepo.saveQuestion(_viewModel.currentQuestion!.id);
        setState(() {
          _isQuestionSaved = true;
        });
        if (mounted) {
          _soundService.playTap();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حفظ السؤال بنجاح')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  void _reportQuestion() {
    String? selectedIssue;
    final issueController = TextEditingController();
    bool isSending = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('التبليغ عن السؤال'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر نوع المشكلة:'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedIssue,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('اختر المشكلة'),
                  items: const [
                    DropdownMenuItem(value: 'خطأ لغوي', child: Text('خطأ لغوي')),
                    DropdownMenuItem(
                        value: 'خطأ في المعلومات',
                        child: Text('خطأ في المعلومات')),
                    DropdownMenuItem(
                        value: 'خطأ في الإجابة', child: Text('خطأ في الإجابة')),
                    DropdownMenuItem(
                        value: 'رابط لا يعمل', child: Text('رابط لا يعمل')),
                    DropdownMenuItem(value: 'أخرى', child: Text('أخرى')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedIssue = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('وصف المشكلة:'),
                const SizedBox(height: 8),
                TextField(
                  controller: issueController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'اكتب تفاصيل المشكلة هنا...',
                  ),
                ),
                if (isSending) ...[
                  const SizedBox(height: 16),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text('جاري الإرسال...'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSending ? null : () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: isSending
                  ? null
                  : () async {
                      if (selectedIssue == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('الرجاء اختيار نوع المشكلة')),
                        );
                        return;
                      }
                      if (issueController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('الرجاء كتابة وصف المشكلة')),
                        );
                        return;
                      }

                      setDialogState(() {
                        isSending = true;
                      });

                      final success = await _sendReportToTelegram(
                        issueType: selectedIssue!,
                        description: issueController.text.trim(),
                      );

                      if (!mounted) return;

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? '✅ تم إرسال البلاغ بنجاح! شكراً لمساعدتك 🙏'
                                : '❌ حدث خطأ. يرجى المحاولة لاحقاً',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
              child: const Text('إرسال'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _sendReportToTelegram({
    required String issueType,
    required String description,
  }) async {
    try {
      const botToken = '8115871408:AAFj5igD1TY7aIsNrFSXhWHiAEu_oT_X_o4';
      const chatId = '1108170970';

      final question = _viewModel.currentQuestion;

      // بناء قائمة الإجابات
      String optionsText = '';
      if (question != null && question.options.isNotEmpty) {
        for (int i = 0; i < question.options.length; i++) {
          final isCorrect = i == question.correctAnswerIndex;
          final prefix = isCorrect ? '✅' : '❌';
          optionsText += '$prefix ${i + 1}. ${question.options[i]}\n';
        }
      }

      final message = '''
🚨 *بلاغ جديد من تطبيق صاحب القرآن*

📋 *نوع المشكلة:* $issueType

📝 *الوصف:*
$description

━━━━━━━━━━━━━━━━
📌 *معلومات السؤال:*
• المعرف: ${question?.id ?? 'غير متوفر'}
• السورة: ${question?.surahId ?? 'غير متوفر'}
• الفئة: ${question?.category.displayName ?? 'غير متوفر'}

❓ *نص السؤال:*
${question?.questionText ?? 'غير متوفر'}

📝 *الإجابات:*
${optionsText.isNotEmpty ? optionsText : 'غير متوفرة'}
✅ *الإجابة الصحيحة:* ${question?.correctAnswer ?? 'غير متوفر'}

📖المصدر:${question?.explanation.isNotEmpty == true ? ' ${question!.explanation}' : ' غير متوفر'}


⏰ التاريخ: ${DateTime.now().toString().split('.')[0]}
''';

      final url = Uri.parse(
          'https://api.telegram.org/bot$botToken/sendMessage');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'chat_id': chatId,
          'text': message,
          'parse_mode': 'Markdown',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error sending Telegram report: $e');
      return false;
    }
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
      return _buildResultScreen();
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
                  icon: Icon(_isQuestionSaved
                      ? Icons.bookmark
                      : Icons.bookmark_border),
                  tooltip: _isQuestionSaved ? 'إلغاء الحفظ' : 'حفظ السؤال',
                  iconSize: 24,
                  color: _isQuestionSaved
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
                    fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize! * _fontSize,
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
                    
                    // Haptic & Sound feedback
                    final isCorrect = index == question.correctAnswerIndex;
                    if (isCorrect) {
                      _soundService.playSuccess();
                    } else {
                      _hapticService.error();
                      _soundService.playError();
                    }
                  },
                ),
              );
            }),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _viewModel.isAnswered
                  ? Column(
                      key: ValueKey('answer_${_viewModel.currentIndex}'),
                      children: [
                        const SizedBox(height: 16),
                        Card(
                          color: _viewModel.selectedAnswerIndex ==
                                  question.correctAnswerIndex
                              ? Colors.green.shade50
                              : Colors.red.shade50,
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
                                      color: _viewModel.selectedAnswerIndex ==
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                if (question.explanation.isNotEmpty)
                                  InkWell(
                                    onTap: () =>
                                        _openLink(question.explanation),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.link,
                                          size: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            question.explanation,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  decoration: TextDecoration
                                                      .underline,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final accuracy =
        (_viewModel.correctCount / _viewModel.totalQuestions * 100).toInt();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              accuracy >= 70 ? Icons.celebration : Icons.info_outline,
              size: 100,
              color: accuracy >= 70 ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              'انتهى الاختبار!',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'النتيجة: ${_viewModel.correctCount}/${_viewModel.totalQuestions}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'الدقة: $accuracy%',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.home),
              label: const Text('العودة للرئيسية'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                _viewModel.reset();
                _viewModel.loadQuestions();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة الاختبار'),
            ),
          ],
        ),
      ),
    );
  }
}
