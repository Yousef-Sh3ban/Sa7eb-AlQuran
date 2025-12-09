import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sa7eb_alquran/presentation/screens/profile_screen.dart';
import '../../data/repositories/surah_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../../data/data_sources/local/database.dart';
import '../../data/models/surah_model.dart';
import '../widgets/surah_card.dart';
import '../widgets/overall_progress_widget.dart';
import '../../main.dart' as main_app;
import '../../core/themes/app_colors.dart';
import '../../core/themes/color_schemes.dart' as app_color_schemes;

/// Main tab navigator with bottom navigation
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ProfileScreen(),
          SettingsScreenPlaceholder(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.onPrimaryContainer),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.onPrimaryContainer),
            label: 'الملف الشخصي',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimaryContainer),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

/// Home screen - displays list of Surahs with search and sorting
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final SurahRepository _surahRepo;
  late final UserProgressRepository _progressRepo;
  List<SurahModel> _allSurahs = [];
  List<SurahModel> _filteredSurahs = [];
  bool _isLoading = true;
  bool _isAscending = true;
  final TextEditingController _searchController = TextEditingController();

  // Overall progress stats
  int _totalQuestions = 0;
  int _answeredQuestions = 0;
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _surahRepo = SurahRepository();
    _progressRepo = UserProgressRepository(AppDatabase());
    _loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // تحديث البيانات عند العودة للتطبيق
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  /// Refresh data (called when returning to screen)
  Future<void> _refreshData() async {
    final stats = await _progressRepo.getOverallStats();
    if (mounted) {
      setState(() {
        _totalQuestions = stats['totalQuestions'] ?? 0;
        _answeredQuestions = stats['answeredQuestions'] ?? 0;
        _correctAnswers = stats['correctAnswers'] ?? 0;
      });
    }
  }

  Future<void> _loadData() async {
    final surahs = await _surahRepo.getAllSurahs();
    final stats = await _progressRepo.getOverallStats();

    setState(() {
      _allSurahs = surahs;
      _filteredSurahs = surahs;
      _totalQuestions = stats['totalQuestions'] ?? 0;
      _answeredQuestions = stats['answeredQuestions'] ?? 0;
      _correctAnswers = stats['correctAnswers'] ?? 0;
      _isLoading = false;
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _filteredSurahs = List.from(_filteredSurahs.reversed);
    });
  }

  void _filterSurahs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSurahs = _allSurahs;
      } else {
        _filteredSurahs = _allSurahs.where((surah) {
          return surah.nameArabic.contains(query) ||
              surah.nameEnglish.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Future<double> _getSurahProgress(int surahId) async {
    return await _progressRepo.getSurahCompletionPercentage(surahId);
  }

  @override
  Widget build(BuildContext context) {
    final completionPercentage = _totalQuestions > 0
        ? (_answeredQuestions / _totalQuestions * 100)
        : 0.0;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Box في الأعلى
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppColors.spacingLarge,
                      AppColors.spacingLarge,
                      AppColors.spacingLarge,
                      AppColors.spacingSmall,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'ابحث عن سورة...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterSurahs('');
                                      },
                                    )
                                  : null,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                                borderSide: BorderSide(
                                  color: AppColors.withOpacity(
                                    Theme.of(context).colorScheme.outline,
                                    AppColors.opacity30,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding: EdgeInsets.symmetric(vertical: AppColors.spacingSmall),
                            ),
                            onChanged: _filterSurahs,
                          ),
                        ),
                        SizedBox(width: AppColors.spacingSmall),
                        // زر الترتيب
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(AppColors.radiusMedium),
                          ),
                          child: IconButton(
                            icon: Icon(
                              _isAscending ? Icons.arrow_downward : Icons.arrow_upward,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                            onPressed: _toggleSortOrder,
                            tooltip: _isAscending ? 'ترتيب تنازلي' : 'ترتيب تصاعدي',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Overall Progress Widget
                OverallProgressWidget(
                  completionPercentage: completionPercentage,
                  totalQuestions: _totalQuestions,
                  answeredQuestions: _answeredQuestions,
                  correctAnswers: _correctAnswers,
                ),
                // Surahs List
                Expanded(
                  child: _filteredSurahs.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'لا توجد نتائج',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredSurahs.length,
                          itemBuilder: (context, index) {
                            final surah = _filteredSurahs[index];
                            return FutureBuilder<double>(
                              future: _getSurahProgress(surah.id),
                              builder: (context, snapshot) {
                                final progress = snapshot.data ?? 0.0;
                                return SurahCard(
                                  surah: surah,
                                  completionPercentage: progress,
                                  onTap: () async {
                                    await context.push('/surah/${surah.id}');
                                    // تحديث البيانات بعد العودة
                                    _refreshData();
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}


/// Settings Screen
class SettingsScreenPlaceholder extends StatefulWidget {
  const SettingsScreenPlaceholder({super.key});

  @override
  State<SettingsScreenPlaceholder> createState() => _SettingsScreenPlaceholderState();
}

class _SettingsScreenPlaceholderState extends State<SettingsScreenPlaceholder> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 40,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الإعدادات',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // المظهر
            _SettingsSection(
              title: 'المظهر',
              icon: Icons.palette,
              children: [
                _SettingsTile(
                  title: 'الوضع الداكن',
                  subtitle: isDarkMode ? 'مفعّل' : 'غير مفعّل',
                  leading: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      main_app.MyApp.of(context)?.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                ),
                _ColorSchemeSelector(),
              ],
            ),
            const SizedBox(height: 16),
            // حول التطبيق
            _SettingsSection(
              title: 'حول التطبيق',
              icon: Icons.info,
              children: [
                _SettingsTile(
                  title: 'الإصدار',
                  subtitle: '1.0.0',
                  leading: Icon(
                    Icons.apps,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                _SettingsTile(
                  title: 'المطور',
                  subtitle: 'صاحب القرآن',
                  leading: Icon(
                    Icons.code,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  const _SettingsTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      leading: leading,
      trailing: trailing,
    );
  }
}

class _ColorSchemeSelector extends StatelessWidget {
  const _ColorSchemeSelector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر لون التطبيق',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(
              6,
              (index) => _ColorOption(index: index),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final int index;

  const _ColorOption({required this.index});

  @override
  Widget build(BuildContext context) {
    final scheme = app_color_schemes.ColorSchemes.getSchemeByIndex(index);
    final isSelected = Theme.of(context).colorScheme.primary.value == scheme.primary.value;

    return InkWell(
      onTap: () {
        main_app.MyApp.of(context)?.setColorScheme(index);
      },
      borderRadius: BorderRadius.circular(AppColors.radiusMedium),
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppColors.radiusMedium),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    scheme.primary,
                    scheme.secondary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    )
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              scheme.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
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
}
