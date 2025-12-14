import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/surah_dashboard_screen.dart';
import '../../presentation/screens/quiz_screen.dart';
import '../../presentation/screens/saved_questions_screen.dart';

/// Application routing configuration using GoRouter.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const MainNavigator(),
        routes: <RouteBase>[
          GoRoute(
            path: 'surah/:surahId',
            name: 'surahDashboard',
            builder: (context, state) {
              final surahId = state.pathParameters['surahId']!;
              return SurahDashboardScreen(surahId: int.parse(surahId));
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'quiz',
                name: 'quiz',
                builder: (context, state) {
                  final surahId = state.pathParameters['surahId']!;
                  final retryMode =
                      state.uri.queryParameters['retryMode'] == 'true';
                  final mixMode =
                      state.uri.queryParameters['mixMode'] == 'true';
                  return QuizScreen(
                    surahId: int.parse(surahId),
                    retryMode: retryMode,
                    mixMode: mixMode,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'saved-questions',
            name: 'savedQuestions',
            builder: (context, state) => const SavedQuestionsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'خطأ: الصفحة غير موجودة',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('العودة للرئيسية'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
