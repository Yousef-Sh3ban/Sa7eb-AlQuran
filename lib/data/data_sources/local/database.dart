import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

/// Questions table
class Questions extends Table {
  TextColumn get id => text()();
  IntColumn get surahId => integer().named('surah_id')();
  TextColumn get category => text()();
  TextColumn get questionText => text().named('question_text')();
  TextColumn get options => text()();
  IntColumn get correctAnswerIndex =>
      integer().named('correct_answer_index')();
  TextColumn get explanation => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User progress table
class UserProgress extends Table {
  TextColumn get questionId =>
      text().named('question_id').references(Questions, #id)();
  IntColumn get status => integer().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttempt =>
      dateTime().named('last_attempt').nullable()();

  @override
  Set<Column> get primaryKey => {questionId};
}

/// Saved questions table
class SavedQuestions extends Table {
  TextColumn get questionId =>
      text().named('question_id').references(Questions, #id)();
  DateTimeColumn get savedAt =>
      dateTime().named('saved_at').withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {questionId};
}

/// App database using Drift ORM
@DriftDatabase(tables: [Questions, UserProgress, SavedQuestions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(savedQuestions);
          }
        },
      );

  Future<List<Question>> getQuestionsBySurah(int surahId) {
    return (select(questions)..where((q) => q.surahId.equals(surahId))).get();
  }
  
  Future<int> getQuestionsCount() async {
    final countQuery = selectOnly(questions)..addColumns([questions.id.count()]);
    final result = await countQuery.getSingle();
    return result.read(questions.id.count()) ?? 0;
  }
  
  Future<void> deleteAllQuestions() {
    return delete(questions).go();
  }

  Future<UserProgressData?> getProgress(String questionId) {
    return (select(userProgress)
          ..where((p) => p.questionId.equals(questionId)))
        .getSingleOrNull();
  }

  /// Get progress for multiple questions in a single query
  Future<List<UserProgressData>> getProgressBatch(List<String> questionIds) {
    if (questionIds.isEmpty) return Future.value([]);
    return (select(userProgress)
          ..where((p) => p.questionId.isIn(questionIds)))
        .get();
  }

  Future<void> upsertProgress(
    String questionId,
    int status,
    int attempts,
  ) {
    return into(userProgress).insert(
      UserProgressCompanion.insert(
        questionId: questionId,
        status: Value(status),
        attempts: Value(attempts),
        lastAttempt: Value(DateTime.now()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  // Saved questions methods
  Future<void> saveQuestion(String questionId) {
    return into(savedQuestions).insert(
      SavedQuestionsCompanion.insert(questionId: questionId),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> unsaveQuestion(String questionId) {
    return (delete(savedQuestions)
          ..where((q) => q.questionId.equals(questionId)))
        .go();
  }

  Future<bool> isQuestionSaved(String questionId) async {
    final result = await (select(savedQuestions)
          ..where((q) => q.questionId.equals(questionId)))
        .getSingleOrNull();
    return result != null;
  }

  Future<List<Question>> getSavedQuestions() {
    return (select(questions).join([
      innerJoin(
        savedQuestions,
        savedQuestions.questionId.equalsExp(questions.id),
      ),
    ])
          ..orderBy([OrderingTerm.desc(savedQuestions.savedAt)]))
        .map((row) => row.readTable(questions))
        .get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sa7eb_alquran.db'));
    return NativeDatabase(file);
  });
}
