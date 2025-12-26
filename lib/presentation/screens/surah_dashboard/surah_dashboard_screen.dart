import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/app_colors.dart';
import '../../../core/utils/stats_calculator.dart';
import '../../../data/data_sources/local/database.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/repositories/question_repository.dart';
import '../../../data/repositories/surah_repository.dart';
import '../../../data/repositories/user_progress_repository.dart';
import 'widgets/smart_actions.dart';
import 'widgets/stats_dashboard.dart';
import 'widgets/surah_header.dart';

/// صفحة تفاصيل السورة - Dashboard
class SurahDashboardScreen extends StatefulWidget {
  const SurahDashboardScreen({required this.surahId, super.key});

  final int surahId;

  @override
  State<SurahDashboardScreen> createState() => _SurahDashboardScreenState();
}

class _SurahDashboardScreenState extends State<SurahDashboardScreen> {
  final SurahRepository _surahRepo = SurahRepository.instance;
  final AppDatabase _database = AppDatabase();

  SurahModel? _surah;
  bool _isLoading = true;

  // الإحصائيات المحسوبة
  QuestionStats _stats = const QuestionStats(
    totalQuestions: 0,
    newQuestions: 0,
    answeredQuestions: 0,
    correctAnswers: 0,
    incorrectAnswers: 0,
    completionRate: 0.0,
    accuracyRate: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final surah = await _surahRepo.getSurahById(widget.surahId);
      if (surah == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final questionRepo = QuestionRepository(_database);
      final progressRepo = UserProgressRepository(_database);

      // تحميل الأسئلة مرة واحدة فقط عند أول استخدام
      final questionsCount = await _database.getQuestionsCount();
      if (questionsCount == 0) {
        await questionRepo.loadQuestionsFromAssets();
      }

      final questions = await questionRepo.getQuestionsBySurah(widget.surahId);
      final questionIds = questions.map((q) => q.id).toList();
      final stats = await progressRepo.getSurahStats(widget.surahId, questionIds);

      if (!mounted) return;

      setState(() {
        _surah = surah;
        _stats = StatsCalculator.calculate(
          totalQuestions: stats.total,
          answeredQuestions: stats.attempts,
          correctAnswers: stats.correct,
        );
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading surah data: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// تحديث الإحصائيات بعد الاختبار
  Future<void> _refreshStats() async {
    await _loadData();
  }

  void _startNewQuiz() async {
    await context.push('/surah/${widget.surahId}/quiz');
    _refreshStats();
  }

  void _retryErrors() async {
    await context.push('/surah/${widget.surahId}/quiz?retryMode=true');
    _refreshStats();
  }

  void _startMixedReview() async {
    await context.push('/surah/${widget.surahId}/quiz?mixMode=true');
    _refreshStats();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_surah == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('لم يتم العثور على السورة')),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          decelerationRate: ScrollDecelerationRate.fast,
        ),
        child: Container(
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              SurahHeader(
                surah: _surah!,
                onBack: () => context.pop(),
              ),
              const SizedBox(height: AppColors.spacingLarge),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppColors.spacingLarge,
                ),
                child: StatsDashboard(stats: _stats),
              ),
              const SizedBox(height: AppColors.spacingXXLarge),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppColors.spacingLarge,
                ),
                child: SmartActions(
                  stats: _stats,
                  onStartNewQuiz: _startNewQuiz,
                  onRetryErrors: _retryErrors,
                  onStartMixedReview: _startMixedReview,
                ),
              ),
              const SizedBox(height: AppColors.spacingXXLarge),
            ],
          ),
        ),
      ),
    );
  }
}
