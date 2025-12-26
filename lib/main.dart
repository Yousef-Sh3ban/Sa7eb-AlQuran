import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/colors_schemes.dart' as app_color_schemes;
import 'core/services/app_settings_service.dart';
import 'data/data_sources/local/database.dart';
import 'data/repositories/question_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة الإعدادات
  await AppSettingsService.instance.init();

  // تحميل الأسئلة الأولية (سريع)
  final database = AppDatabase();
  final questionRepo = QuestionRepository(database);
  await questionRepo.loadQuestionsFromAssets();

  // تحميل باقي الأسئلة في الخلفية
  _loadRemainingQuestionsInBackground(questionRepo);

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final colorSchemeIndex = prefs.getInt('colorSchemeIndex') ?? 0;
  runApp(MyApp(isDarkMode: isDarkMode, colorSchemeIndex: colorSchemeIndex));
}

/// Load all remaining questions in background (non-blocking)
void _loadRemainingQuestionsInBackground(QuestionRepository repo) {
  Future.microtask(() async {
    try {
      await repo.loadAllQuestions();
    } catch (e) {
      debugPrint('Background question loading failed: $e');
    }
  });
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final int colorSchemeIndex;

  const MyApp({
    super.key,
    required this.isDarkMode,
    required this.colorSchemeIndex,
  });

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late app_color_schemes.ColorScheme _colorScheme;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _colorScheme = app_color_schemes.ColorSchemes.getSchemeByIndex(
      widget.colorSchemeIndex,
    );
  }

  void setThemeMode(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', mode == ThemeMode.dark);
  }

  void setColorScheme(int index) async {
    setState(() {
      _colorScheme = app_color_schemes.ColorSchemes.getSchemeByIndex(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('colorSchemeIndex', index);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'صاحب القران',
      theme: AppTheme.lightTheme(_colorScheme),
      darkTheme: AppTheme.darkTheme(_colorScheme),
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
