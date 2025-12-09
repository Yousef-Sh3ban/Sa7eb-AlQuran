import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../models/question_model.dart';
import '../data_sources/local/database.dart';
import '../../domain/entities/question_category.dart';

/// Repository for managing questions data
class QuestionRepository {
  QuestionRepository(this._database);

  final AppDatabase _database;

  /// Load questions from JSON and save to database
  Future<void> loadQuestionsFromAssets() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/dummy_questions.json');
    final Map<String, dynamic> data = json.decode(jsonString);
    final List<dynamic> questionsJson = data['questions'] as List<dynamic>;

    for (final dynamic questionJson in questionsJson) {
      final QuestionModel question =
          QuestionModel.fromJson(questionJson as Map<String, dynamic>);
      await _saveQuestion(question);
    }
  }

  /// Save a single question to database
  Future<void> _saveQuestion(QuestionModel question) async {
    await _database.into(_database.questions).insert(
          QuestionsCompanion.insert(
            id: question.id,
            surahId: question.surahId,
            category: question.category.name,
            questionText: question.questionText,
            options: json.encode(question.options),
            correctAnswerIndex: question.correctAnswerIndex,
            explanation: question.explanation,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Get all questions for a specific surah
  Future<List<QuestionModel>> getQuestionsBySurah(int surahId) async {
    final List<Question> dbQuestions =
        await _database.getQuestionsBySurah(surahId);
    return dbQuestions.map(_mapToModel).toList();
  }

  /// Get question by ID
  Future<QuestionModel?> getQuestionById(String questionId) async {
    final Question? question = await (_database.select(_database.questions)
          ..where((q) => q.id.equals(questionId)))
        .getSingleOrNull();

    return question != null ? _mapToModel(question) : null;
  }

  /// Map database Question to QuestionModel
  QuestionModel _mapToModel(Question question) {
    return QuestionModel(
      id: question.id,
      surahId: question.surahId,
      category: QuestionCategory.values.firstWhere(
        (c) => c.name == question.category,
      ),
      questionText: question.questionText,
      options: (json.decode(question.options) as List<dynamic>)
          .cast<String>(),
      correctAnswerIndex: question.correctAnswerIndex,
      explanation: question.explanation,
    );
  }
}
