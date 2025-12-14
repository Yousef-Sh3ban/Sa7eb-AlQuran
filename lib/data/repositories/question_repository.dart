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
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/tafseer_database.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      
      print('📚 Starting to load questions...');
      
      // البنية: topics -> كل topic هو سورة -> كل topic فيه (pack0, pack1, pack2, ...)
      final List<dynamic> topics = data['topics'] as List<dynamic>;
      if (topics.isEmpty) {
        print('⚠️ No topics found in tafseer_database.json');
        return;
      }
      
      int totalQuestionsLoaded = 0;
      
      // قراءة كل الـ topics (كل topic = سورة واحدة)
      for (int topicIndex = 0; topicIndex < topics.length; topicIndex++) {
        final Map<String, dynamic> topicMap = topics[topicIndex] as Map<String, dynamic>;
        
        print('📖 Loading topic ${topicIndex + 1}/${topics.length}...');
        
        // قراءة كل الـ packs في الـ topic (pack0, pack1, pack2, ...)
        for (final packKey in topicMap.keys) {
          if (packKey.startsWith('pack')) {
            final List<dynamic> questionsJson = topicMap[packKey] as List<dynamic>;

            for (final dynamic questionJson in questionsJson) {
              final Map<String, dynamic> questionMap = questionJson as Map<String, dynamic>;
              
              // التحقق من وجود الحقول المطلوبة
              if (!questionMap.containsKey('surah_id') || questionMap['surah_id'] == null) {
                continue;
              }
              
              if (!questionMap.containsKey('answers') || questionMap['answers'] == null) {
                continue;
              }
              
              // تحويل البنية الجديدة إلى البنية القديمة
              final List<dynamic> answers = questionMap['answers'] as List<dynamic>;
              final List<String> options = [];
              int correctIndex = 0;
              
              for (int i = 0; i < answers.length; i++) {
                final answer = answers[i] as Map<String, dynamic>;
                options.add(answer['answer'] as String);
                if (answer['t'] == 1) {
                  correctIndex = i;
                }
              }
              
              // إنشاء QuestionModel - استخدام الـ id الأصلي مباشرة
              final question = QuestionModel(
                id: questionMap['id'].toString(),
                surahId: questionMap['surah_id'] as int,
                category: QuestionCategory.fromString(questionMap['category'] as String? ?? 'tafseer'),
                questionText: questionMap['question_text'] as String,
                options: options,
                correctAnswerIndex: correctIndex,
                explanation: questionMap['link'] as String? ?? '',
              );
              
              await _saveQuestion(question);
              totalQuestionsLoaded++;
            }
          }
        }
      }
      
      print('✅ Successfully loaded $totalQuestionsLoaded questions from ${topics.length} topics');
    } catch (e, stackTrace) {
      print('❌ Error loading questions: $e');
      print('Stack trace: $stackTrace');
      rethrow;
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
