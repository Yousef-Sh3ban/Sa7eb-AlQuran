import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/data_sources/local/database.dart';
import '../../data/repositories/question_repository.dart';
import '../../data/repositories/user_progress_repository.dart';
import '../view_models/quiz_view_model.dart';
import '../widgets/quiz_progress_indicator.dart';
import '../widgets/question_category_badge.dart';
import '../widgets/answer_button.dart';

/// Quiz screen for answering questions
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    required this.surahId,
    this.retryMode = false,
    this.mixMode = false,
    super.key,
  });

  final int surahId;
  final bool retryMode;
  final bool mixMode;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final QuizViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final database = AppDatabase();
    _viewModel = QuizViewModel(
      surahId: widget.surahId,
      retryMode: widget.retryMode,
      mixMode: widget.mixMode,
      questionRepo: QuestionRepository(database),
      progressRepo: UserProgressRepository(database),
    );
    _viewModel.loadQuestions();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.retryMode ? 'مراجعة الأخطاء' : 'الاختبار'),
        actions: [
          if (!_viewModel.isLoading && !_viewModel.isQuizComplete)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '${_viewModel.currentIndex + 1}/${_viewModel.totalQuestions}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_viewModel.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_viewModel.errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('العودة'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.isQuizComplete) {
      return _buildResultScreen();
    }

    return _buildQuestionScreen();
  }

  Widget _buildQuestionScreen() {
    final question = _viewModel.currentQuestion!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          QuizProgressIndicator(
            currentIndex: _viewModel.currentIndex,
            totalQuestions: _viewModel.totalQuestions,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionCategoryBadge(category: question.category),
                  const SizedBox(height: 16),
                  Text(
                    question.questionText,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(question.options.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AnswerButton(
                text: question.options[index],
                index: index,
                onPressed: () => _viewModel.selectAnswer(index),
                isSelected: _viewModel.selectedAnswerIndex == index,
                isCorrect: index == question.correctAnswerIndex,
                isAnswered: _viewModel.isAnswered,
              ),
            );
          }),
          if (_viewModel.isAnswered) ...[
            const SizedBox(height: 16),
            Card(
              color: _viewModel.selectedAnswerIndex ==
                      question.correctAnswerIndex
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _viewModel.selectedAnswerIndex ==
                                  question.correctAnswerIndex
                              ? Icons.check_circle
                              : Icons.cancel,
                          color: _viewModel.selectedAnswerIndex ==
                                  question.correctAnswerIndex
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _viewModel.selectedAnswerIndex ==
                                  question.correctAnswerIndex
                              ? 'إجابة صحيحة!'
                              : 'إجابة خاطئة',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'التفسير: ${question.explanation}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _viewModel.nextQuestion,
              child: const Text('السؤال التالي'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final accuracy =
        (_viewModel.correctCount / _viewModel.totalQuestions * 100).toInt();

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
              'النتيجة: ${_viewModel.correctCount}/${_viewModel.totalQuestions}',
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
              onPressed: () {
                _viewModel.reset();
                _viewModel.loadQuestions();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة الاختبار'),
            ),
          ],
        ),
      ),
    );
  }
}
