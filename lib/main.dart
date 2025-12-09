import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/color_schemes.dart' as app_color_schemes;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final colorSchemeIndex = prefs.getInt('colorSchemeIndex') ?? 0;
  runApp(MyApp(
    isDarkMode: isDarkMode,
    colorSchemeIndex: colorSchemeIndex,
  ));
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
    _colorScheme = app_color_schemes.ColorSchemes.getSchemeByIndex(widget.colorSchemeIndex);
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
      title: 'صاحب القرآن',
      theme: AppTheme.lightTheme(_colorScheme),
      darkTheme: AppTheme.darkTheme(_colorScheme),
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [
        Locale('ar', 'SA'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
