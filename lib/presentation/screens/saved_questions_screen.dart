import 'package:flutter/material.dart';
import '../../data/data_sources/local/database.dart';
import '../../data/repositories/saved_questions_repository.dart';
import '../../data/models/question_model.dart';
import '../widgets/question_category_badge.dart';

/// Screen to display saved questions
class SavedQuestionsScreen extends StatefulWidget {
  const SavedQuestionsScreen({super.key});

  @override
  State<SavedQuestionsScreen> createState() => _SavedQuestionsScreenState();
}

class _SavedQuestionsScreenState extends State<SavedQuestionsScreen> {
  late final SavedQuestionsRepository _repository;
  List<QuestionModel> _savedQuestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = SavedQuestionsRepository(AppDatabase());
    _loadSavedQuestions();
  }

  Future<void> _loadSavedQuestions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final questions = await _repository.getSavedQuestions();
      if (mounted) {
        setState(() {
          _savedQuestions = questions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل الأسئلة: $e')),
        );
      }
    }
  }

  Future<void> _unsaveQuestion(String questionId) async {
    try {
      await _repository.unsaveQuestion(questionId);
      await _loadSavedQuestions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إزالة السؤال من المحفوظات')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأسئلة المحفوظة'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedQuestions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد أسئلة محفوظة',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'احفظ الأسئلة المهمة أثناء الاختبار',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadSavedQuestions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _savedQuestions.length,
                    itemBuilder: (context, index) {
                      final question = _savedQuestions[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  QuestionCategoryBadge(
                                      category: question.category),
                                  const SizedBox(width: 8),
                                  Text(
                                    'سورة ${question.surahId}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () =>
                                        _unsaveQuestion(question.id),
                                    icon: const Icon(Icons.delete_outline),
                                    color: Colors.red.shade400,
                                    tooltip: 'حذف',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                question.questionText,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              ...question.options.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final option = entry.value;
                                final isCorrect =
                                    idx == question.correctAnswerIndex;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        size: 20,
                                        color: isCorrect
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: isCorrect
                                                    ? Colors.green.shade700
                                                    : null,
                                                fontWeight: isCorrect
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
