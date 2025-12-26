import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Widget displaying the quiz result screen.
class QuizResultView extends StatelessWidget {
  const QuizResultView({
    required this.correctCount,
    required this.totalQuestions,
    required this.onRetry,
    this.onResetProgress,
    super.key,
  });

  final int correctCount;
  final int totalQuestions;
  final VoidCallback onRetry;
  final VoidCallback? onResetProgress;

  @override
  Widget build(BuildContext context) {
    final accuracy = (correctCount / totalQuestions * 100).toInt();

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
              'النتيجة: $correctCount/$totalQuestions',
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
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة الاختبار'),
            ),
            if (onResetProgress != null) ...[
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: () => _showResetConfirmation(context),
                icon: const Icon(Icons.restart_alt),
                label: const Text('إعادة تعيين التقدم'),
                style: TextButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة تعيين التقدم'),
        content: const Text(
          'هل أنت متأكد؟ سيتم حذف جميع تقدمك في هذه السورة والبدء من جديد.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onResetProgress?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }
}
