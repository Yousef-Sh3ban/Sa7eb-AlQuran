import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/themes/app_colors.dart';
import '../../data/repositories/user_profile_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/data_sources/local/database.dart';

/// صفحة ملف المستخدم الشخصي
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

  @override
  void initState() {
    super.initState();
    _progressRepo = UserProgressRepository(AppDatabase());
    _loadData();
  }

  /// تحميل البيانات من قاعدة البيانات و SharedPreferences
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      // تحميل بيانات الملف الشخصي
      _userName = await _profileRepo.getUserName();
      _userImage = await _profileRepo.getUserImage();
      _weekActivity = await _profileRepo.getWeekActivity();
      
      // تحميل الإحصائيات من قاعدة البيانات
      final stats = await _progressRepo.getOverallStats();
      _totalQuestions = stats['totalQuestions'] ?? 0;
      _answeredQuestions = stats['answeredQuestions'] ?? 0;
      _correctAnswers = stats['correctAnswers'] ?? 0;
      
      // حساب الدقة
      _accuracy = _answeredQuestions > 0 
          ? (_correctAnswers / _answeredQuestions) * 100 
          : 0.0;
      
      // الحصول على اللقب بناءً على عدد الأسئلة المُجابة
      _userTitle = _profileRepo.getUserTitle(_answeredQuestions);
      
      // حساب سلسلة الأيام المتتالية
      _dayStreak = _calculateDayStreak();
      
      // حساب عدد السور المكتملة (TODO: تنفيذ منطق حقيقي)
      _completedSurahs = 0;
      
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    }
    
    setState(() => _isLoading = false);
  }
  
  /// حساب عدد الأيام المتتالية
  int _calculateDayStreak() {
    int streak = 0;
    final today = DateTime.now().weekday - 1; // 0 = Monday
    
    // Count backwards from today
    for (int i = today; i >= 0; i--) {
      if (_weekActivity[i]) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  /// فتح منتقي الصور
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    
    if (image != null) {
      await _profileRepo.setUserImage(image.path);
      setState(() {
        _userImage = image.path;
      });
    }
  }
  
  /// تعديل الاسم
  Future<void> _editName() async {
    final TextEditingController controller = TextEditingController(text: _userName);
    
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
      setState(() {
        _userName = result;
      });
    }
  }
  
  /// عرض قواعد الترقية
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

  // الإنجازات
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // القسم العلوي: رأس الملف الشخصي مع تدرج لوني
            _buildProfileHeader(theme),
            
            const SizedBox(height: AppColors.spacingLarge),
            
            // نشاط الأسبوع
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: _buildWeeklyActivity(theme),
            ),
            
            const SizedBox(height: AppColors.spacingLarge),
            
            // إحصائيات التعلم
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: _buildLearningStatistics(theme),
            ),
            
            const SizedBox(height: AppColors.spacingLarge),
            
            // زر الأسئلة المحفوظة
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: _buildSavedQuestionsButton(theme),
            ),
            
            const SizedBox(height: AppColors.spacingLarge),
            
            // الإنجازات
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppColors.spacingLarge),
              child: _buildAchievements(theme),
            ),
            
            const SizedBox(height: AppColors.spacingXXLarge),
          ],
        ),
      ),
    );
  }

  /// بناء رأس الملف الشخصي
  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppColors.radiusXLarge),
          bottomRight: Radius.circular(AppColors.radiusXLarge),
        ),
      ),
      padding: const EdgeInsets.only(
        top: AppColors.spacingXXLarge * 2,
        bottom: AppColors.spacingXXLarge,
        left: AppColors.spacingLarge,
        right: AppColors.spacingLarge,
      ),
      child: Column(
        children: [
          // الأفاتار
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: _userImage != null ? FileImage(File(_userImage!)) : null,
                  child: _userImage == null
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppColors.spacingLarge),
          
          // الاسم مع زر التعديل
          InkWell(
            onTap: _editName,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _userName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: AppColors.spacingSmall),
                const Icon(
                  Icons.edit,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppColors.spacingSmall),
          
          // اللقب مع علامة التعجب للقواعد
          InkWell(
            onTap: _showTitleRules,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _userTitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: AppColors.spacingSmall),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppColors.spacingXXLarge),
          
          // بطاقات الإحصائيات السريعة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStatCard(
                theme,
                icon: Icons.local_fire_department,
                label: 'أيام متتالية',
                value: _dayStreak.toString(),
                color: Colors.orange,
              ),
              _buildQuickStatCard(
                theme,
                icon: Icons.quiz,
                label: 'الأسئلة',
                value: _answeredQuestions.toString(),
                color: Colors.blue,
              ),
              _buildQuickStatCard(
                theme,
                icon: Icons.gps_fixed,
                label: 'الدقة',
                value: '${_accuracy.toStringAsFixed(1)}%',
                color: AppColors.getAccuracyColor(_accuracy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// بناء بطاقة إحصائية سريعة
  Widget _buildQuickStatCard(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppColors.spacingSmall),
        padding: const EdgeInsets.all(AppColors.spacingMedium),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: AppColors.iconSizeMedium),
            const SizedBox(height: AppColors.spacingSmall),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: AppColors.spacingXSmall),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// بناء نشاط الأسبوع
  Widget _buildWeeklyActivity(ThemeData theme) {
    return Card(
      elevation: AppColors.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'نشاط هذا الأسبوع',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final dayName = ['إث', 'ثل', 'أرب', 'خم', 'جم', 'سب', 'أحد'][index];
                final isCompleted = _weekActivity[index];
                final isCurrent = (DateTime.now().weekday - 1) == index;
                
                return _buildDayIndicator(
                  theme,
                  day: dayName,
                  isCompleted: isCompleted,
                  isCurrent: isCurrent,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء مؤشر اليوم
  Widget _buildDayIndicator(
    ThemeData theme, {
    required String day,
    required bool isCompleted,
    required bool isCurrent,
  }) {
    // تحديد لون الدائرة
    Color circleColor;
    if (isCurrent && isCompleted) {
      circleColor = Colors.amber; // اللون المميز لليوم الحالي المكتمل
    } else if (isCompleted) {
      circleColor = theme.colorScheme.primary;
    } else if (isCurrent) {
      circleColor = theme.colorScheme.primaryContainer; // لون مختلف لليوم الحالي غير المكتمل
    } else {
      circleColor = theme.colorScheme.surfaceContainerHighest;
    }
    
    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: isCurrent
                ? Border.all(
                    color: Colors.amber,
                    width: 2.5,
                  )
                : null,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.local_fire_department,
                    color: isCurrent ? Colors.white : Colors.white,
                    size: 24,
                  )
                : Text(
                    day,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isCurrent
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppColors.spacingXSmall),
        Text(
          day,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isCurrent
                ? Colors.amber
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// بناء إحصائيات التعلم
  Widget _buildLearningStatistics(ThemeData theme) {
    return Card(
      elevation: AppColors.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إحصائيات التعلم',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            // السور المكتملة
            Padding(
              padding: const EdgeInsets.only(bottom: AppColors.spacingMedium),
              child: _buildStatisticItem(
                theme,
                icon: Icons.book_outlined,
                title: 'السور المكتملة',
                subtitle: 'أنهيت جميع أسئلتها',
                value: _completedSurahs.toString(),
                color: Colors.blue,
              ),
            ),
            // الأسئلة المجابة
            Padding(
              padding: const EdgeInsets.only(bottom: AppColors.spacingMedium),
              child: _buildStatisticItem(
                theme,
                icon: Icons.quiz_outlined,
                title: 'الأسئلة المجابة',
                subtitle: 'من إجمالي $_totalQuestions سؤال',
                value: _answeredQuestions.toString(),
                color: Colors.green,
              ),
            ),
            // الإجابات الصحيحة
            Padding(
              padding: const EdgeInsets.only(bottom: AppColors.spacingMedium),
              child: _buildStatisticItem(
                theme,
                icon: Icons.check_circle_outline,
                title: 'الإجابات الصحيحة',
                subtitle: 'نسبة الصواب',
                value: '${_accuracy.toStringAsFixed(1)}%',
                color: AppColors.getAccuracyColor(_accuracy),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// بناء عنصر إحصائي
  Widget _buildStatisticItem(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppColors.spacingMedium),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppColors.spacingMedium),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            ),
            child: Icon(icon, color: Colors.white, size: AppColors.iconSizeMedium),
          ),
          const SizedBox(width: AppColors.spacingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppColors.spacingXSmall),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// بناء زر الأسئلة المحفوظة
  Widget _buildSavedQuestionsButton(ThemeData theme) {
    return ElevatedButton.icon(
      onPressed: () {
        // TODO: الانتقال إلى صفحة الأسئلة المحفوظة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ستتم إضافة صفحة الأسئلة المحفوظة قريباً'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppColors.spacingLarge),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
        ),
      ),
      icon: const Icon(Icons.bookmark),
      label: const Text('الأسئلة المحفوظة'),
    );
  }

  /// بناء الإنجازات
  Widget _buildAchievements(ThemeData theme) {
    return Card(
      elevation: AppColors.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppColors.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإنجازات',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: AppColors.spacingMedium,
                mainAxisSpacing: AppColors.spacingMedium,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return _buildAchievementBadge(
                  theme,
                  icon: achievement['icon'] as IconData,
                  title: achievement['title'] as String,
                  description: achievement['description'] as String,
                  unlocked: achievement['unlocked'] as bool,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// بناء شارة الإنجاز
  Widget _buildAchievementBadge(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required bool unlocked,
  }) {
    return InkWell(
      onTap: () {
        _showAchievementDetails(theme, icon, title, description, unlocked);
      },
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: Container(
        decoration: BoxDecoration(
          color: unlocked
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(
            color: unlocked
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: AppColors.iconSizeLarge,
                  color: unlocked
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                if (!unlocked)
                  Icon(
                    Icons.lock,
                    size: AppColors.iconSizeSmall,
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                if (unlocked)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppColors.spacingSmall),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: unlocked
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// عرض تفاصيل الإنجاز
  void _showAchievementDetails(
    ThemeData theme,
    IconData icon,
    String title,
    String description,
    bool unlocked,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusLarge),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppColors.spacingLarge),
              decoration: BoxDecoration(
                color: unlocked
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: unlocked
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: AppColors.spacingLarge),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppColors.spacingSmall),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppColors.spacingSmall),
            if (unlocked)
              Chip(
                avatar: const Icon(Icons.check, size: 16),
                label: const Text('مفتوح'),
                backgroundColor: theme.colorScheme.primaryContainer,
              )
            else
              Chip(
                avatar: const Icon(Icons.lock, size: 16),
                label: const Text('مقفل'),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
