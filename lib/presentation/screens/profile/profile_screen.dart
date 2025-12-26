import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/themes/app_colors.dart';
import '../../../data/data_sources/local/database.dart';
import '../../../data/repositories/user_profile_repository.dart';
import '../../../data/repositories/user_progress_repository.dart';
import 'widgets/achievements_section.dart';
import 'widgets/learning_statistics_section.dart';
import 'widgets/profile_header.dart';
import 'widgets/saved_questions_button.dart';
import 'widgets/weekly_activity_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserProfileRepository _profileRepo = UserProfileRepository();
  late final UserProgressRepository _progressRepo;

  // البيانات الحقيقية
  String _userName = 'طالب العلم';
  String? _userImage;
  String _userTitle = 'طالب مبتدئ';
  int _dayStreak = 0;
  int _totalQuestions = 0;
  int _answeredQuestions = 0;
  int _correctAnswers = 0;
  double _accuracy = 0.0;
  int _completedSurahs = 0;
  List<bool> _weekActivity = List.filled(7, false);
  bool _isLoading = true;

  // الإنجازات (ثابتة حالياً)
  final List<Map<String, dynamic>> achievements = [
    {
      'icon': Icons.rocket_launch,
      'title': 'الخطوات الأولى',
      'description': 'أكمل 10 أسئلة',
      'unlocked': true,
    },
    {
      'icon': Icons.local_fire_department,
      'title': 'المتحمس',
      'description': '7 أيام متتالية',
      'unlocked': true,
    },
    {
      'icon': Icons.emoji_events,
      'title': 'الخبير',
      'description': 'دقة 90% أو أكثر',
      'unlocked': true,
    },
    {
      'icon': Icons.star,
      'title': 'النجم الساطع',
      'description': 'أكمل 5 سور',
      'unlocked': false,
    },
    {
      'icon': Icons.workspace_premium,
      'title': 'المحترف',
      'description': 'أجب على 500 سؤال',
      'unlocked': false,
    },
    {
      'icon': Icons.diamond,
      'title': 'الماسي',
      'description': '30 يوم متتالي',
      'unlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _progressRepo = UserProgressRepository(AppDatabase());
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      _userName = await _profileRepo.getUserName();
      _userImage = await _profileRepo.getUserImage();
      _weekActivity = await _profileRepo.getWeekActivity();

      final stats = await _progressRepo.getOverallStats();
      _totalQuestions = stats['totalQuestions'] ?? 0;
      _answeredQuestions = stats['answeredQuestions'] ?? 0;
      _correctAnswers = stats['correctAnswers'] ?? 0;

      _accuracy = _answeredQuestions > 0
          ? (_correctAnswers / _answeredQuestions) * 100
          : 0.0;

      _userTitle = _profileRepo.getUserTitle(_answeredQuestions);
      _dayStreak = _calculateDayStreak();
      _completedSurahs = 0; // TODO: implement real logic
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  int _calculateDayStreak() {
    int streak = 0;
    final today = DateTime.now().weekday - 1; // 0 = Monday
    for (int i = today; i >= 0; i--) {
      if (_weekActivity[i]) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (image != null) {
      await _profileRepo.setUserImage(image.path);
      if (mounted) setState(() => _userImage = image.path);
    }
  }

  Future<void> _editName() async {
    final controller = TextEditingController(text: _userName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        title: const Text('تعديل الاسم'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'الاسم',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _profileRepo.setUserName(result);
      if (mounted) setState(() => _userName = result);
    }
  }

  void _showTitleRules() {
    final rules = _profileRepo.getTitleRules();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: AppColors.spacingSmall),
            const Text('قواعد الترقية'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: rules.map((rule) {
              final from = rule['from'] as int;
              final to = rule['to'] as int?;
              final title = rule['title'] as String;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppColors.spacingSmall),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        to != null ? '$from - $to سؤال' : '$from+ سؤال',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const Icon(Icons.arrow_back, size: 16),
                    const SizedBox(width: AppColors.spacingSmall),
                    Expanded(
                      flex: 2,
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  File? _resolveUserImage() {
    if (_userImage == null || _userImage!.isEmpty) return null;
    final file = File(_userImage!);
    return file.existsSync() ? file : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final weeklyActivityCounts = _weekActivity.map((day) => day ? 1 : 0).toList();
    final maxWeeklyActivity = weeklyActivityCounts.fold<int>(0, math.max);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.fast),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileHeader(
              theme: theme,
              userName: _userName,
              userTitle: _userTitle,
              userImage: _resolveUserImage(),
              dayStreak: _dayStreak,
              answeredQuestions: _answeredQuestions,
              accuracy: _accuracy,
              onEditName: _editName,
              onPickImage: _pickImage,
              onShowTitleRules: _showTitleRules,
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: WeeklyActivitySection(
                theme: theme,
                weeklyActivity: weeklyActivityCounts,
                maxWeeklyActivity: maxWeeklyActivity,
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: LearningStatisticsSection(
                theme: theme,
                totalQuestions: _totalQuestions,
                answeredQuestions: _answeredQuestions,
                correctAnswers: _correctAnswers,
                completedSurahs: _completedSurahs,
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: SavedQuestionsButton(
                theme: theme,
                onTap: () => context.push('/saved-questions'),
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: AchievementsSection(
                theme: theme,
                achievements: achievements
                    .where((item) => item['unlocked'] == true)
                    .map((item) => item['title'] as String)
                    .toList(),
              ),
            ),
            const SizedBox(height: AppColors.spacingXXLarge),
          ],
        ),
      ),
    );
  }
}
