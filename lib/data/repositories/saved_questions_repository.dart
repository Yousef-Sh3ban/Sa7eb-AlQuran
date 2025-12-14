import '../data_sources/local/database.dart';
import '../models/question_model.dart';
import '../../domain/entities/question_category.dart';

/// Repository for managing saved questions
class SavedQuestionsRepository {
  SavedQuestionsRepository(this._database);

  final AppDatabase _database;

  /// Save a question
  Future<void> saveQuestion(String questionId) async {
    await _database.saveQuestion(questionId);
  }

  /// Remove a saved question
  Future<void> unsaveQuestion(String questionId) async {
    await _database.unsaveQuestion(questionId);
  }

  /// Check if a question is saved
  Future<bool> isQuestionSaved(String questionId) async {
    return await _database.isQuestionSaved(questionId);
  }

  /// Get all saved questions
  Future<List<QuestionModel>> getSavedQuestions() async {
    final questions = await _database.getSavedQuestions();
    return questions.map((q) {
      final optionsList = q.options.split('|||');
      return QuestionModel(
        id: q.id,
        surahId: q.surahId,
        category: QuestionCategory.fromString(q.category),
        questionText: q.questionText,
        options: optionsList,
        correctAnswerIndex: q.correctAnswerIndex,
        explanation: q.explanation,
      );
    }).toList();
  }
}
