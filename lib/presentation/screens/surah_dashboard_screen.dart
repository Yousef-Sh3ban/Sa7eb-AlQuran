import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/surah_repository.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/data_sources/local/database.dart';
import '../../data/models/surah_model.dart';
import '../../core/themes/app_colors.dart';

/// صفحة تفاصيل السورة - Dashboard
class SurahDashboardScreen extends StatefulWidget {
  const SurahDashboardScreen({required this.surahId, super.key});

  final int surahId;

  @override
  State<SurahDashboardScreen> createState() => _SurahDashboardScreenState();
}

class _SurahDashboardScreenState extends State<SurahDashboardScreen>
    with TickerProviderStateMixin {
  final SurahRepository _surahRepo = SurahRepository();
  final AppDatabase _database = AppDatabase();

  SurahModel? _surah;
  bool _isLoading = true;

  // الإحصائيات
  int _totalQuestions = 0;
  int _answeredQuestions = 0;
  int _correctAnswers = 0;
  int _incorrectAnswers = 0;

  // النسب المئوية
  double _completionRate = 0.0;
  double _accuracyRate = 0.0;

  // حالة الأزرار
  bool _hasNewQuestions = true;
  bool _hasErrors = false;
  bool _isMasterMode = false;

  late AnimationController _badgeController;

  @override
  void initState() {
    super.initState();
    _badgeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _badgeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      print('🔍 Loading surah with ID: ${widget.surahId}');
      final surah = await _surahRepo.getSurahById(widget.surahId);

      if (surah == null) {
        print('❌ Surah not found with ID: ${widget.surahId}');
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      print('✅ Surah found: ${surah.nameArabic}');

      final questionRepo = QuestionRepository(_database);
      final progressRepo = UserProgressRepository(_database);

      // تحميل الأسئلة مرة واحدة فقط عند أول استخدام
      final questionsCount = await _database.getQuestionsCount();
      if (questionsCount == 0) {
        print('📥 First time: Loading all questions from assets...');
        await questionRepo.loadQuestionsFromAssets();
      } else {
        print(
          '✅ Questions already loaded ($questionsCount questions in database)',
        );
      }

      print('🔎 Getting questions for surah ${widget.surahId}...');
      final questions = await questionRepo.getQuestionsBySurah(widget.surahId);
      print('📊 Found ${questions.length} questions');

      final questionIds = questions.map((q) => q.id).toList();
      final stats = await progressRepo.getSurahStats(
        widget.surahId,
        questionIds,
      );

      // حساب عدد الأخطاء
      int incorrectCount = 0;
      for (final questionId in questionIds) {
        final progress = await progressRepo.getProgress(questionId);
        if (progress != null && progress.status == 1) {
          incorrectCount++;
        }
      }

      if (mounted) {
        setState(() {
          _surah = surah;
          _totalQuestions = stats.total;
          _answeredQuestions = stats.attempts;
          _correctAnswers = stats.correct;
          _incorrectAnswers = incorrectCount;

          // حساب النسب
          _completionRate = _totalQuestions > 0
              ? (_answeredQuestions / _totalQuestions) * 100
              : 0.0;
          _accuracyRate = _answeredQuestions > 0
              ? (_correctAnswers / _answeredQuestions) * 100
              : 0.0;

          // تحديد حالة الأزرار
          _hasNewQuestions = _answeredQuestions < _totalQuestions;
          _hasErrors = _incorrectAnswers > 0;
          _isMasterMode = _completionRate >= 100 && _accuracyRate >= 100;

          _isLoading = false;

          // تشغيل أنيميشن الوسام إذا كان في وضع الإتقان
          if (_isMasterMode) {
            _badgeController.repeat();
          }
        });

        print('✅ Dashboard loaded successfully');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error loading surah data: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Refresh stats after quiz
  Future<void> _refreshStats() async {
    await _loadData();
  }

  /// بدء اختبار جديد
  void _startNewQuiz() async {
    await context.push('/surah/${widget.surahId}/quiz');
    _refreshStats();
  }

  /// تصحيح الأخطاء
  void _retryErrors() async {
    await context.push('/surah/${widget.surahId}/quiz?retryMode=true');
    _refreshStats();
  }

  /// اختبار مراجعة عام (Mix)
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
              // 1. رأس الصفحة (Header - الهوية)
              _buildHeader(theme),
          
              const SizedBox(height: AppColors.spacingLarge),
          
              // 2. لوحة الإنجاز (Stats Dashboard)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppColors.spacingLarge,
                ),
                child: _buildStatsDashboard(theme),
              ),
          
              const SizedBox(height: AppColors.spacingXXLarge),
          
              // 3. منطقة الأزرار الذكية (Smart Actions)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppColors.spacingLarge,
                ),
                child: _buildSmartActions(theme),
              ),
          
              const SizedBox(height: AppColors.spacingXXLarge),
            ],
          ),
        ),
      ),
    );
  }

  /// بناء رأس الصفحة
  Widget _buildHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppColors.radiusXLarge),
          bottomRight: Radius.circular(AppColors.radiusXLarge),
        ),
      ),
      padding: const EdgeInsets.only(
        top: AppColors.spacingXXLarge * 2.5,
        bottom: AppColors.spacingXXLarge,
        left: AppColors.spacingLarge,
        right: AppColors.spacingLarge,
      ),
      child: Column(
        children: [
          const SizedBox(height: AppColors.spacingLarge),
          // زر الرجوع واسم السورة
          Stack(
            alignment: Alignment.center,
            children: [
              // اسم السورة في المنتصف
              Center(
                child: Text(
                  _surah!.nameArabic,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SurahNameMadina',
                    fontSize: 70,
                  ),
                ),
              ),
              // زر الرجوع على اليمين
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppColors.spacingSmall),

          // اسم السورة بالإنجليزي
          Text(
            _surah!.nameEnglish,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),

          const SizedBox(height: AppColors.spacingXXLarge),

          // بطاقات المعلومات (Badges Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoBadge(
                theme,
                icon: Icons.abc,
                label: _surah!.revelationType == 'meccan' ? 'مكية' : 'مدنية',
                color: Colors.amber,
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildInfoBadge(
                theme,
                icon: Icons.abc,
                label: '${_surah!.totalAyahs} آية',
                color: Colors.blue,
              ),
              Container(
                width: 1,
                height: 16,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildInfoBadge(
                theme,
                icon: Icons.abc,
                label: 'ترتيب ${_surah!.id}',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء بطاقة معلومة صغيرة
  Widget _buildInfoBadge(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Text(
      label,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: Colors.white.withValues(alpha: 0.95),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// بناء لوحة الإنجاز
  Widget _buildStatsDashboard(ThemeData theme) {
    return Card(
      elevation: AppColors.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingXXLarge),
        child: Column(
          children: [
            // الوسام
            Center(child: _buildBadge(theme)),

            // مؤشرات الدقة والتقدم
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircularIndicator(
                  theme,
                  label: 'الدقة',
                  value: _accuracyRate,
                  color: AppColors.getAccuracyColor(_accuracyRate),
                ),

                _buildCircularIndicator(
                  theme,
                  label: 'التقدم',
                  value: _completionRate,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),

            const SizedBox(height: AppColors.spacingLarge),

            // بطاقات الإحصائيات الثلاثية
            _buildStatsCards(theme),
          ],
        ),
      ),
    );
  }

  /// بناء مؤشر دائري
  Widget _buildCircularIndicator(
    ThemeData theme, {
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          // color: Colors.black,
          width: 110,
          height: 110,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  value: value / 100,
                  strokeWidth: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '${value.toStringAsFixed(0)}%',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// بناء الوسام
  Widget _buildBadge(ThemeData theme) {
    return GestureDetector(
      onTap: !_isMasterMode
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'احصل على دقة 100% لفتح الوسام! 🏆',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: theme.colorScheme.primary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          : null,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isMasterMode
              ? AppColors.success.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: _isMasterMode
                ? AppColors.success
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 3,
          ),
        ),
        child: Icon(
          _isMasterMode ? Icons.emoji_events : Icons.lock_outline,
          size: 45,
          color: _isMasterMode
              ? AppColors.golden
              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  /// بناء بطاقات الإحصائيات الثلاثية
  Widget _buildStatsCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            number: '$_totalQuestions',
            label: 'الأسئلة',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: AppColors.spacingSmall),
        Expanded(
          child: _buildStatCard(
            theme,
            number: '$_answeredQuestions',
            label: 'مكتملة',
            isPrimary: true,
          ),
        ),
        const SizedBox(width: AppColors.spacingSmall),
        Expanded(
          child: _buildStatCard(
            theme,
            number: '${_totalQuestions - _answeredQuestions}',
            label: 'متبقية',
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  /// بناء بطاقة إحصائية واحدة
  Widget _buildStatCard(
    ThemeData theme, {
    required String number,
    required String label,
    required bool isPrimary,
  }) {
    final bgColor = isPrimary
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.secondaryContainer;
    final borderColor = isPrimary
        ? theme.colorScheme.primary
        : theme.colorScheme.secondary;
    final textColor = isPrimary
        ? theme.colorScheme.onPrimaryContainer
        : theme.colorScheme.onSecondaryContainer;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppColors.spacingMedium,
        horizontal: AppColors.spacingSmall,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            number,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء منطقة الأزرار الذكية
  Widget _buildSmartActions(ThemeData theme) {
    return Card(
      elevation: AppColors.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingXXLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // الحالة 1: يوجد أسئلة جديدة
            if (_hasNewQuestions) ...[
              _buildPrimaryButton(
                theme,
                label: 'تابع التحدي',
                subtitle: 'أسئلة جديدة بانتظارك',
                icon: Icons.rocket_launch,
                onPressed: _startNewQuiz,
              ),
              const SizedBox(height: AppColors.spacingLarge),
              _buildSecondaryButton(
                theme,
                label: 'تصحيح الأخطاء',
                subtitle: _hasErrors
                    ? '$_incorrectAnswers خطأ'
                    : 'لا توجد أخطاء',
                icon: Icons.replay,
                onPressed: _hasErrors ? _retryErrors : null,
              ),
            ]
            // الحالة 2: لا يوجد جديد لكن يوجد أخطاء
            else if (_hasErrors) ...[
              _buildPrimaryButton(
                theme,
                label: 'مراجعة وإعادة حل',
                subtitle: 'اختبار عشوائي للتثبيت',
                icon: Icons.shuffle,
                onPressed: _startMixedReview,
              ),
              const SizedBox(height: AppColors.spacingLarge),
              _buildSecondaryButton(
                theme,
                label: 'تصحيح الأخطاء المتبقية',
                subtitle: '$_incorrectAnswers خطأ متبقي',
                icon: Icons.replay,
                onPressed: _retryErrors,
              ),
            ]
            // الحالة 3: الأستاذ (100% + 100%)
            else if (_isMasterMode) ...[
              _buildMasterButton(
                theme,
                label: 'مراجعة وإعادة حل',
                subtitle: 'اختبار عشوائي للتثبيت',
                icon: Icons.refresh,
                onPressed: _startMixedReview,
              ),
              const SizedBox(height: AppColors.spacingMedium),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, color: AppColors.success, size: 20),
                  const SizedBox(width: AppColors.spacingSmall),
                  Text(
                    'مبارك! أتقنت هذه السورة 🎉',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// زر رئيسي
  Widget _buildPrimaryButton(
    ThemeData theme, {
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 32),
          const SizedBox(width: AppColors.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_back),
        ],
      ),
    );
  }

  /// زر ثانوي
  Widget _buildSecondaryButton(
    ThemeData theme, {
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
        side: BorderSide(
          color: onPressed != null
              ? theme.colorScheme.outline
              : theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: AppColors.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_back,
            color: onPressed != null
                ? null
                : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  /// زر المراجعة (Master Mode)
  Widget _buildMasterButton(
    ThemeData theme, {
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.success, AppColors.success.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppColors.spacingLarge),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 32, color: Colors.white),
                const SizedBox(width: AppColors.spacingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_back, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
