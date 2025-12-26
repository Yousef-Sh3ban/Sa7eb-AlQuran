import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/themes/app_colors.dart';
import '../../../data/data_sources/local/database.dart';
import '../../../data/models/surah_model.dart';
import '../../../data/repositories/surah_repository.dart';
import '../../../data/repositories/user_progress_repository.dart';
import '../../widgets/overall_progress_widget.dart';
import '../../widgets/surah_card.dart';

/// Home screen - displays list of Surahs with search and sorting.
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
    _surahRepo = SurahRepository.instance;
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
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    final stats = await _progressRepo.getOverallStats();
    if (!mounted) return;
    setState(() {
      _totalQuestions = stats['totalQuestions'] ?? 0;
      _answeredQuestions = stats['answeredQuestions'] ?? 0;
      _correctAnswers = stats['correctAnswers'] ?? 0;
    });
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
    return _progressRepo.getSurahCompletionPercentage(surahId);
  }

  @override
  Widget build(BuildContext context) {
    final completionPercentage = _totalQuestions > 0
        ? (_answeredQuestions / _totalQuestions * 100)
        : 0.0;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Column(
          children: [
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
                            borderRadius: BorderRadius.circular(
                              AppColors.radiusMedium,
                            ),
                            borderSide: BorderSide(
                              color: AppColors.withOpacity(
                                Theme.of(context).colorScheme.outline,
                                AppColors.opacity30,
                              ),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppColors.radiusMedium,
                            ),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: AppColors.spacingSmall,
                          ),
                        ),
                        onChanged: _filterSurahs,
                      ),
                    ),
                    const SizedBox(width: AppColors.spacingSmall),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(
                          AppColors.radiusMedium,
                        ),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isAscending
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                        ),
                        onPressed: _toggleSortOrder,
                        tooltip: _isAscending ? 'ترتيب تنازلي' : 'ترتيب تصاعدي',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            OverallProgressWidget(
              completionPercentage: completionPercentage,
              totalQuestions: _totalQuestions,
              answeredQuestions: _answeredQuestions,
              correctAnswers: _correctAnswers,
            ),
            Expanded(
              child: _filteredSurahs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
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
      ),
    );
  }
}
