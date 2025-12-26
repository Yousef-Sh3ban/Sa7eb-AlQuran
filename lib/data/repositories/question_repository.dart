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

  /// سور التحميل المبدئي: الفاتحة، أول 5 سور، ثم جزء عمّ
  static final Set<int> _initialSurahs = {
    1,
    2,
    3,
    4,
    5,
    ...List<int>.generate(114 - 77, (i) => 78 + i),
  };

  static const List<String> _wordMeaningAssets = <String>[
    'assets/data/mcqs_batch1.json',
    'assets/data/mcqs_batch2.json',
  ];

  /// Load initial questions from JSON (fast startup)
  /// This loads only initial surahs for quick startup
  Future<void> loadQuestionsFromAssets() async {
    try {
      print('📚 Starting staged preload: Fatiha, first 5, then Juz Amma');
      await _loadTafseerQuestionsFromAssets(filterSurahIds: _initialSurahs);
      await _loadWordMeaningQuestionsFromAssets(filterSurahIds: _initialSurahs);
      print('✅ Preload finished for initial surahs (${_initialSurahs.length})');
    } catch (e, stackTrace) {
      print('❌ Error loading questions: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Load ALL questions from JSON (complete database)
  /// Call this in background after app startup completes
  Future<void> loadAllQuestions() async {
    try {
      print('📚 Loading ALL questions from assets...');
      await _loadTafseerQuestionsFromAssets(); // No filter = load all
      await _loadWordMeaningQuestionsFromAssets(); // No filter = load all
      print('✅ All questions loaded successfully');
    } catch (e, stackTrace) {
      print('❌ Error loading all questions: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Load questions for a single surah on demand if missing (both tafseer and word meaning)
  Future<void> _ensureSurahLoaded(int surahId) async {
    await _loadTafseerQuestionsFromAssets(filterSurahIds: {surahId});
    await _loadWordMeaningQuestionsFromAssets(filterSurahIds: {surahId});
  }

  Future<void> _loadTafseerQuestionsFromAssets({
    Set<int>? filterSurahIds,
  }) async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/tafseer_database.json',
    );
    final Map<String, dynamic> data = json.decode(jsonString);

    final List<dynamic> topics = data['topics'] as List<dynamic>;
    if (topics.isEmpty) {
      print('⚠️ No topics found in tafseer_database.json');
      return;
    }

    int loaded = 0;

    for (int topicIndex = 0; topicIndex < topics.length; topicIndex++) {
      final Map<String, dynamic> topicMap =
          topics[topicIndex] as Map<String, dynamic>;

      for (final packKey in topicMap.keys) {
        if (!packKey.startsWith('pack')) continue;

        final List<dynamic> questionsJson = topicMap[packKey] as List<dynamic>;

        for (final dynamic questionJson in questionsJson) {
          final Map<String, dynamic> questionMap =
              questionJson as Map<String, dynamic>;

          final int? surahId = questionMap['surah_id'] as int?;
          if (surahId == null) continue;
          if (filterSurahIds != null && !filterSurahIds.contains(surahId)) {
            continue;
          }

          final List<dynamic>? answers =
              questionMap['answers'] as List<dynamic>?;
          if (answers == null) continue;

          final List<String> options = [];
          int correctIndex = 0;

          for (int i = 0; i < answers.length; i++) {
            final answer = answers[i] as Map<String, dynamic>;
            options.add(answer['answer'] as String);
            if (answer['t'] == 1) {
              correctIndex = i;
            }
          }

          final category = QuestionCategory.fromString(
            questionMap['category'] as String? ?? 'tafseer',
          );
          // Prefix ID with category to ensure uniqueness across types
          final uniqueId = '${category.name}_${questionMap['id']}';

          final question = QuestionModel(
            id: uniqueId,
            surahId: surahId,
            category: category,
            questionText: questionMap['question_text'] as String,
            options: options,
            correctAnswerIndex: correctIndex,
            explanation: questionMap['link'] as String? ?? '',
          );

          await _saveQuestion(question);
          loaded++;
        }
      }
    }

    if (loaded > 0) {
      print('✅ Loaded $loaded tafseer questions');
    }
  }

  Future<void> _loadWordMeaningQuestionsFromAssets({
    Set<int>? filterSurahIds,
  }) async {
    int loaded = 0;

    for (final assetPath in _wordMeaningAssets) {
      final String jsonString = await rootBundle.loadString(assetPath);
      final List<dynamic> questions = json.decode(jsonString) as List<dynamic>;

      for (final dynamic questionJson in questions) {
        final Map<String, dynamic> questionMap =
            questionJson as Map<String, dynamic>;

        final int? surahId = questionMap['surah_id'] as int?;
        if (surahId == null) continue;
        if (filterSurahIds != null && !filterSurahIds.contains(surahId)) {
          continue;
        }

        final List<dynamic>? answers = questionMap['answers'] as List<dynamic>?;
        if (answers == null) continue;

        final List<String> options = [];
        int correctIndex = 0;

        for (int i = 0; i < answers.length; i++) {
          final answer = answers[i] as Map<String, dynamic>;
          options.add(answer['answer'] as String);
          if (answer['t'] == 1) {
            correctIndex = i;
          }
        }

        final category = QuestionCategory.fromString(
          questionMap['category'] as String? ?? 'word_meaning',
        );
        // Prefix ID with category to ensure uniqueness across types
        final uniqueId = '${category.name}_${questionMap['id']}';

        final question = QuestionModel(
          id: uniqueId,
          surahId: surahId,
          category: category,
          questionText: questionMap['question_text'] as String,
          options: options,
          correctAnswerIndex: correctIndex,
          explanation: questionMap['explanation'] as String? ?? '',
        );

        await _saveQuestion(question);
        loaded++;
      }
    }

    if (loaded > 0) {
      print('✅ Loaded $loaded word-meaning questions');
    }
  }

  /// Save a single question to database
  Future<void> _saveQuestion(QuestionModel question) async {
    await _database
        .into(_database.questions)
        .insert(
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
    List<Question> dbQuestions = await _database.getQuestionsBySurah(surahId);

    final bool hasWordMeaning = dbQuestions.any(
      (q) => q.category == QuestionCategory.wordMeaning.name,
    );
    final bool hasAny = dbQuestions.isNotEmpty;

    // تحميل كسول إذا لم توجد أسئلة، أو لا توجد أسئلة معاني لهذه السورة
    if (!hasAny || !hasWordMeaning) {
      await _ensureSurahLoaded(surahId);
      dbQuestions = await _database.getQuestionsBySurah(surahId);
    }

    return dbQuestions.map(_mapToModel).toList();
  }

  /// Get question by ID
  Future<QuestionModel?> getQuestionById(String questionId) async {
    final Question? question = await (_database.select(
      _database.questions,
    )..where((q) => q.id.equals(questionId))).getSingleOrNull();

    return question != null ? _mapToModel(question) : null;
  }

  /// Clear all questions from database (useful for migration or fixing corrupted data)
  Future<void> clearAllQuestions() async {
    await _database.delete(_database.questions).go();
    print('✅ Cleared all questions from database');
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
      options: (json.decode(question.options) as List<dynamic>).cast<String>(),
      correctAnswerIndex: question.correctAnswerIndex,
      explanation: question.explanation,
    );
  }
}
