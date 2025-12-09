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

/// App database using Drift ORM
@DriftDatabase(tables: [Questions, UserProgress])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Question>> getQuestionsBySurah(int surahId) {
    return (select(questions)..where((q) => q.surahId.equals(surahId))).get();
  }

  Future<UserProgressData?> getProgress(String questionId) {
    return (select(userProgress)
          ..where((p) => p.questionId.equals(questionId)))
        .getSingleOrNull();
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sa7eb_alquran.db'));
    return NativeDatabase(file);
  });
}
