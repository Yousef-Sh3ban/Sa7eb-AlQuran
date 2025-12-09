import 'package:flutter/material.dart';

/// Progress indicator widget for quiz
class QuizProgressIndicator extends StatelessWidget {
  const QuizProgressIndicator({
    required this.currentIndex,
    required this.totalQuestions,
    super.key,
  });

  final int currentIndex;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    final progress = totalQuestions > 0 ? currentIndex / totalQuestions : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'السؤال ${currentIndex + 1} من $totalQuestions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
          ),
        ),
      ],
    );
  }
}
