import 'package:flutter/material.dart';
import '../../data/models/question_model.dart';
import '../widgets/question_category_badge.dart';
import '../../core/services/app_settings_service.dart';
import '../../core/utils/url_utils.dart';

/// Screen to view a single saved question with its answer state
class SavedQuestionViewScreen extends StatefulWidget {
  const SavedQuestionViewScreen({
    required this.question,
    required this.surahName,
    super.key,
  });

  final QuestionModel question;
  final String surahName;

  @override
  State<SavedQuestionViewScreen> createState() =>
      _SavedQuestionViewScreenState();
}

class _SavedQuestionViewScreenState extends State<SavedQuestionViewScreen> {
  final _settingsService = AppSettingsService.instance;
  double _fontSize = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.init();
    setState(() {
      _fontSize = _settingsService.getFontSize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.question;

    return Scaffold(
      appBar: AppBar(title: const Text('السؤال المحفوظ')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with category and surah name
            Row(
              children: [
                QuestionCategoryBadge(category: question.category),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'سورة ${widget.surahName}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SurahNameMadina',
                      fontSize: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Question text
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize:
                    Theme.of(context).textTheme.headlineSmall!.fontSize! *
                    _fontSize,
              ),
            ),
            const SizedBox(height: 24),
            // Answer options (static view with highlight for correct answer)
            ...List.generate(question.options.length, (index) {
              final isCorrect = index == question.correctAnswerIndex;
              final badge = String.fromCharCode(65 + index);
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green : Colors.transparent,
                  border: Border.all(
                    color: isCorrect ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCorrect
                            ? Colors.white.withOpacity(0.3)
                            : Colors.grey.shade200,
                        border: Border.all(
                          color: isCorrect
                              ? Colors.white
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: isCorrect
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.options[index],
                        style: TextStyle(
                          fontSize: 16 * _fontSize,
                          color: isCorrect ? Colors.white : null,
                        ),
                      ),
                    ),
                    if (isCorrect)
                      const Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            // Explanation card
            if (question.explanation.isNotEmpty)
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'إجابة صحيحة!',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final isLink = isValidHttpUrl(question.explanation);
                          if (isLink) {
                            return InkWell(
                              onTap: () => launchExternalUrl(
                                context,
                                question.explanation,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 18,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      question.explanation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return Text(
                            question.explanation,
                            style: Theme.of(context).textTheme.bodyMedium,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
