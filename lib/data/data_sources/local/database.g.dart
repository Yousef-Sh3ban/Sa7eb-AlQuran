// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surahIdMeta = const VerificationMeta(
    'surahId',
  );
  @override
  late final GeneratedColumn<int> surahId = GeneratedColumn<int>(
    'surah_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsMeta = const VerificationMeta(
    'options',
  );
  @override
  late final GeneratedColumn<String> options = GeneratedColumn<String>(
    'options',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctAnswerIndexMeta =
      const VerificationMeta('correctAnswerIndex');
  @override
  late final GeneratedColumn<int> correctAnswerIndex = GeneratedColumn<int>(
    'correct_answer_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahId,
    category,
    questionText,
    options,
    correctAnswerIndex,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('surah_id')) {
      context.handle(
        _surahIdMeta,
        surahId.isAcceptableOrUnknown(data['surah_id']!, _surahIdMeta),
      );
    } else if (isInserting) {
      context.missing(_surahIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('options')) {
      context.handle(
        _optionsMeta,
        options.isAcceptableOrUnknown(data['options']!, _optionsMeta),
      );
    } else if (isInserting) {
      context.missing(_optionsMeta);
    }
    if (data.containsKey('correct_answer_index')) {
      context.handle(
        _correctAnswerIndexMeta,
        correctAnswerIndex.isAcceptableOrUnknown(
          data['correct_answer_index']!,
          _correctAnswerIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctAnswerIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      surahId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      options: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options'],
      )!,
      correctAnswerIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_answer_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final int surahId;
  final String category;
  final String questionText;
  final String options;
  final int correctAnswerIndex;
  final String explanation;
  const Question({
    required this.id,
    required this.surahId,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['surah_id'] = Variable<int>(surahId);
    map['category'] = Variable<String>(category);
    map['question_text'] = Variable<String>(questionText);
    map['options'] = Variable<String>(options);
    map['correct_answer_index'] = Variable<int>(correctAnswerIndex);
    map['explanation'] = Variable<String>(explanation);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      surahId: Value(surahId),
      category: Value(category),
      questionText: Value(questionText),
      options: Value(options),
      correctAnswerIndex: Value(correctAnswerIndex),
      explanation: Value(explanation),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      surahId: serializer.fromJson<int>(json['surahId']),
      category: serializer.fromJson<String>(json['category']),
      questionText: serializer.fromJson<String>(json['questionText']),
      options: serializer.fromJson<String>(json['options']),
      correctAnswerIndex: serializer.fromJson<int>(json['correctAnswerIndex']),
      explanation: serializer.fromJson<String>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'surahId': serializer.toJson<int>(surahId),
      'category': serializer.toJson<String>(category),
      'questionText': serializer.toJson<String>(questionText),
      'options': serializer.toJson<String>(options),
      'correctAnswerIndex': serializer.toJson<int>(correctAnswerIndex),
      'explanation': serializer.toJson<String>(explanation),
    };
  }

  Question copyWith({
    String? id,
    int? surahId,
    String? category,
    String? questionText,
    String? options,
    int? correctAnswerIndex,
    String? explanation,
  }) => Question(
    id: id ?? this.id,
    surahId: surahId ?? this.surahId,
    category: category ?? this.category,
    questionText: questionText ?? this.questionText,
    options: options ?? this.options,
    correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    explanation: explanation ?? this.explanation,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      surahId: data.surahId.present ? data.surahId.value : this.surahId,
      category: data.category.present ? data.category.value : this.category,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      options: data.options.present ? data.options.value : this.options,
      correctAnswerIndex: data.correctAnswerIndex.present
          ? data.correctAnswerIndex.value
          : this.correctAnswerIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('category: $category, ')
          ..write('questionText: $questionText, ')
          ..write('options: $options, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahId,
    category,
    questionText,
    options,
    correctAnswerIndex,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.surahId == this.surahId &&
          other.category == this.category &&
          other.questionText == this.questionText &&
          other.options == this.options &&
          other.correctAnswerIndex == this.correctAnswerIndex &&
          other.explanation == this.explanation);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<int> surahId;
  final Value<String> category;
  final Value<String> questionText;
  final Value<String> options;
  final Value<int> correctAnswerIndex;
  final Value<String> explanation;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.surahId = const Value.absent(),
    this.category = const Value.absent(),
    this.questionText = const Value.absent(),
    this.options = const Value.absent(),
    this.correctAnswerIndex = const Value.absent(),
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required int surahId,
    required String category,
    required String questionText,
    required String options,
    required int correctAnswerIndex,
    required String explanation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       surahId = Value(surahId),
       category = Value(category),
       questionText = Value(questionText),
       options = Value(options),
       correctAnswerIndex = Value(correctAnswerIndex),
       explanation = Value(explanation);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<int>? surahId,
    Expression<String>? category,
    Expression<String>? questionText,
    Expression<String>? options,
    Expression<int>? correctAnswerIndex,
    Expression<String>? explanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahId != null) 'surah_id': surahId,
      if (category != null) 'category': category,
      if (questionText != null) 'question_text': questionText,
      if (options != null) 'options': options,
      if (correctAnswerIndex != null)
        'correct_answer_index': correctAnswerIndex,
      if (explanation != null) 'explanation': explanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<int>? surahId,
    Value<String>? category,
    Value<String>? questionText,
    Value<String>? options,
    Value<int>? correctAnswerIndex,
    Value<String>? explanation,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      surahId: surahId ?? this.surahId,
      category: category ?? this.category,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
      explanation: explanation ?? this.explanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (surahId.present) {
      map['surah_id'] = Variable<int>(surahId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(options.value);
    }
    if (correctAnswerIndex.present) {
      map['correct_answer_index'] = Variable<int>(correctAnswerIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('surahId: $surahId, ')
          ..write('category: $category, ')
          ..write('questionText: $questionText, ')
          ..write('options: $options, ')
          ..write('correctAnswerIndex: $correctAnswerIndex, ')
          ..write('explanation: $explanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProgressTable extends UserProgress
    with TableInfo<$UserProgressTable, UserProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastAttemptMeta = const VerificationMeta(
    'lastAttempt',
  );
  @override
  late final GeneratedColumn<DateTime> lastAttempt = GeneratedColumn<DateTime>(
    'last_attempt',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    questionId,
    status,
    attempts,
    lastAttempt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_attempt')) {
      context.handle(
        _lastAttemptMeta,
        lastAttempt.isAcceptableOrUnknown(
          data['last_attempt']!,
          _lastAttemptMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  UserProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProgressData(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastAttempt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_attempt'],
      ),
    );
  }

  @override
  $UserProgressTable createAlias(String alias) {
    return $UserProgressTable(attachedDatabase, alias);
  }
}

class UserProgressData extends DataClass
    implements Insertable<UserProgressData> {
  final String questionId;
  final int status;
  final int attempts;
  final DateTime? lastAttempt;
  const UserProgressData({
    required this.questionId,
    required this.status,
    required this.attempts,
    this.lastAttempt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['status'] = Variable<int>(status);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastAttempt != null) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt);
    }
    return map;
  }

  UserProgressCompanion toCompanion(bool nullToAbsent) {
    return UserProgressCompanion(
      questionId: Value(questionId),
      status: Value(status),
      attempts: Value(attempts),
      lastAttempt: lastAttempt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttempt),
    );
  }

  factory UserProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProgressData(
      questionId: serializer.fromJson<String>(json['questionId']),
      status: serializer.fromJson<int>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastAttempt: serializer.fromJson<DateTime?>(json['lastAttempt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'status': serializer.toJson<int>(status),
      'attempts': serializer.toJson<int>(attempts),
      'lastAttempt': serializer.toJson<DateTime?>(lastAttempt),
    };
  }

  UserProgressData copyWith({
    String? questionId,
    int? status,
    int? attempts,
    Value<DateTime?> lastAttempt = const Value.absent(),
  }) => UserProgressData(
    questionId: questionId ?? this.questionId,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    lastAttempt: lastAttempt.present ? lastAttempt.value : this.lastAttempt,
  );
  UserProgressData copyWithCompanion(UserProgressCompanion data) {
    return UserProgressData(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastAttempt: data.lastAttempt.present
          ? data.lastAttempt.value
          : this.lastAttempt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressData(')
          ..write('questionId: $questionId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastAttempt: $lastAttempt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, status, attempts, lastAttempt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProgressData &&
          other.questionId == this.questionId &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.lastAttempt == this.lastAttempt);
}

class UserProgressCompanion extends UpdateCompanion<UserProgressData> {
  final Value<String> questionId;
  final Value<int> status;
  final Value<int> attempts;
  final Value<DateTime?> lastAttempt;
  final Value<int> rowid;
  const UserProgressCompanion({
    this.questionId = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProgressCompanion.insert({
    required String questionId,
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastAttempt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId);
  static Insertable<UserProgressData> custom({
    Expression<String>? questionId,
    Expression<int>? status,
    Expression<int>? attempts,
    Expression<DateTime>? lastAttempt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (lastAttempt != null) 'last_attempt': lastAttempt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProgressCompanion copyWith({
    Value<String>? questionId,
    Value<int>? status,
    Value<int>? attempts,
    Value<DateTime?>? lastAttempt,
    Value<int>? rowid,
  }) {
    return UserProgressCompanion(
      questionId: questionId ?? this.questionId,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastAttempt: lastAttempt ?? this.lastAttempt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastAttempt.present) {
      map['last_attempt'] = Variable<DateTime>(lastAttempt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProgressCompanion(')
          ..write('questionId: $questionId, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('lastAttempt: $lastAttempt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedQuestionsTable extends SavedQuestions
    with TableInfo<$SavedQuestionsTable, SavedQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES questions (id)',
    ),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [questionId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  SavedQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedQuestion(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedQuestionsTable createAlias(String alias) {
    return $SavedQuestionsTable(attachedDatabase, alias);
  }
}

class SavedQuestion extends DataClass implements Insertable<SavedQuestion> {
  final String questionId;
  final DateTime savedAt;
  const SavedQuestion({required this.questionId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedQuestionsCompanion toCompanion(bool nullToAbsent) {
    return SavedQuestionsCompanion(
      questionId: Value(questionId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedQuestion(
      questionId: serializer.fromJson<String>(json['questionId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedQuestion copyWith({String? questionId, DateTime? savedAt}) =>
      SavedQuestion(
        questionId: questionId ?? this.questionId,
        savedAt: savedAt ?? this.savedAt,
      );
  SavedQuestion copyWithCompanion(SavedQuestionsCompanion data) {
    return SavedQuestion(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedQuestion(')
          ..write('questionId: $questionId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedQuestion &&
          other.questionId == this.questionId &&
          other.savedAt == this.savedAt);
}

class SavedQuestionsCompanion extends UpdateCompanion<SavedQuestion> {
  final Value<String> questionId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedQuestionsCompanion({
    this.questionId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedQuestionsCompanion.insert({
    required String questionId,
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId);
  static Insertable<SavedQuestion> custom({
    Expression<String>? questionId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedQuestionsCompanion copyWith({
    Value<String>? questionId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedQuestionsCompanion(
      questionId: questionId ?? this.questionId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedQuestionsCompanion(')
          ..write('questionId: $questionId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $UserProgressTable userProgress = $UserProgressTable(this);
  late final $SavedQuestionsTable savedQuestions = $SavedQuestionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    questions,
    userProgress,
    savedQuestions,
  ];
}

typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      required String id,
      required int surahId,
      required String category,
      required String questionText,
      required String options,
      required int correctAnswerIndex,
      required String explanation,
      Value<int> rowid,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<String> id,
      Value<int> surahId,
      Value<String> category,
      Value<String> questionText,
      Value<String> options,
      Value<int> correctAnswerIndex,
      Value<String> explanation,
      Value<int> rowid,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserProgressTable, List<UserProgressData>>
  _userProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userProgress,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.userProgress.questionId,
    ),
  );

  $$UserProgressTableProcessedTableManager get userProgressRefs {
    final manager = $$UserProgressTableTableManager(
      $_db,
      $_db.userProgress,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_userProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavedQuestionsTable, List<SavedQuestion>>
  _savedQuestionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.savedQuestions,
    aliasName: $_aliasNameGenerator(
      db.questions.id,
      db.savedQuestions.questionId,
    ),
  );

  $$SavedQuestionsTableProcessedTableManager get savedQuestionsRefs {
    final manager = $$SavedQuestionsTableTableManager(
      $_db,
      $_db.savedQuestions,
    ).filter((f) => f.questionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_savedQuestionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userProgressRefs(
    Expression<bool> Function($$UserProgressTableFilterComposer f) f,
  ) {
    final $$UserProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableFilterComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savedQuestionsRefs(
    Expression<bool> Function($$SavedQuestionsTableFilterComposer f) f,
  ) {
    final $$SavedQuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedQuestionsTableFilterComposer(
            $db: $db,
            $table: $db.savedQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahId => $composableBuilder(
    column: $table.surahId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahId =>
      $composableBuilder(column: $table.surahId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get correctAnswerIndex => $composableBuilder(
    column: $table.correctAnswerIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  Expression<T> userProgressRefs<T extends Object>(
    Expression<T> Function($$UserProgressTableAnnotationComposer a) f,
  ) {
    final $$UserProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userProgress,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.userProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savedQuestionsRefs<T extends Object>(
    Expression<T> Function($$SavedQuestionsTableAnnotationComposer a) f,
  ) {
    final $$SavedQuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedQuestions,
      getReferencedColumn: (t) => t.questionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedQuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.savedQuestions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({
            bool userProgressRefs,
            bool savedQuestionsRefs,
          })
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> surahId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> options = const Value.absent(),
                Value<int> correctAnswerIndex = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                surahId: surahId,
                category: category,
                questionText: questionText,
                options: options,
                correctAnswerIndex: correctAnswerIndex,
                explanation: explanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int surahId,
                required String category,
                required String questionText,
                required String options,
                required int correctAnswerIndex,
                required String explanation,
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                surahId: surahId,
                category: category,
                questionText: questionText,
                options: options,
                correctAnswerIndex: correctAnswerIndex,
                explanation: explanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userProgressRefs = false, savedQuestionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userProgressRefs) db.userProgress,
                    if (savedQuestionsRefs) db.savedQuestions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userProgressRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          UserProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._userProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).userProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (savedQuestionsRefs)
                        await $_getPrefetchedData<
                          Question,
                          $QuestionsTable,
                          SavedQuestion
                        >(
                          currentTable: table,
                          referencedTable: $$QuestionsTableReferences
                              ._savedQuestionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuestionsTableReferences(
                                db,
                                table,
                                p0,
                              ).savedQuestionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.questionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({bool userProgressRefs, bool savedQuestionsRefs})
    >;
typedef $$UserProgressTableCreateCompanionBuilder =
    UserProgressCompanion Function({
      required String questionId,
      Value<int> status,
      Value<int> attempts,
      Value<DateTime?> lastAttempt,
      Value<int> rowid,
    });
typedef $$UserProgressTableUpdateCompanionBuilder =
    UserProgressCompanion Function({
      Value<String> questionId,
      Value<int> status,
      Value<int> attempts,
      Value<DateTime?> lastAttempt,
      Value<int> rowid,
    });

final class $$UserProgressTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserProgressTable, UserProgressData> {
  $$UserProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.userProgress.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserProgressTableFilterComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProgressTable> {
  $$UserProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttempt => $composableBuilder(
    column: $table.lastAttempt,
    builder: (column) => column,
  );

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProgressTable,
          UserProgressData,
          $$UserProgressTableFilterComposer,
          $$UserProgressTableOrderingComposer,
          $$UserProgressTableAnnotationComposer,
          $$UserProgressTableCreateCompanionBuilder,
          $$UserProgressTableUpdateCompanionBuilder,
          (UserProgressData, $$UserProgressTableReferences),
          UserProgressData,
          PrefetchHooks Function({bool questionId})
        > {
  $$UserProgressTableTableManager(_$AppDatabase db, $UserProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> lastAttempt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProgressCompanion(
                questionId: questionId,
                status: status,
                attempts: attempts,
                lastAttempt: lastAttempt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                Value<int> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime?> lastAttempt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProgressCompanion.insert(
                questionId: questionId,
                status: status,
                attempts: attempts,
                lastAttempt: lastAttempt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$UserProgressTableReferences
                                    ._questionIdTable(db),
                                referencedColumn: $$UserProgressTableReferences
                                    ._questionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProgressTable,
      UserProgressData,
      $$UserProgressTableFilterComposer,
      $$UserProgressTableOrderingComposer,
      $$UserProgressTableAnnotationComposer,
      $$UserProgressTableCreateCompanionBuilder,
      $$UserProgressTableUpdateCompanionBuilder,
      (UserProgressData, $$UserProgressTableReferences),
      UserProgressData,
      PrefetchHooks Function({bool questionId})
    >;
typedef $$SavedQuestionsTableCreateCompanionBuilder =
    SavedQuestionsCompanion Function({
      required String questionId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });
typedef $$SavedQuestionsTableUpdateCompanionBuilder =
    SavedQuestionsCompanion Function({
      Value<String> questionId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

final class $$SavedQuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $SavedQuestionsTable, SavedQuestion> {
  $$SavedQuestionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $QuestionsTable _questionIdTable(_$AppDatabase db) =>
      db.questions.createAlias(
        $_aliasNameGenerator(db.savedQuestions.questionId, db.questions.id),
      );

  $$QuestionsTableProcessedTableManager get questionId {
    final $_column = $_itemColumn<String>('question_id')!;

    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_questionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavedQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$QuestionsTableFilterComposer get questionId {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuestionsTableOrderingComposer get questionId {
    final $$QuestionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableOrderingComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedQuestionsTable> {
  $$SavedQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$QuestionsTableAnnotationComposer get questionId {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.questionId,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedQuestionsTable,
          SavedQuestion,
          $$SavedQuestionsTableFilterComposer,
          $$SavedQuestionsTableOrderingComposer,
          $$SavedQuestionsTableAnnotationComposer,
          $$SavedQuestionsTableCreateCompanionBuilder,
          $$SavedQuestionsTableUpdateCompanionBuilder,
          (SavedQuestion, $$SavedQuestionsTableReferences),
          SavedQuestion,
          PrefetchHooks Function({bool questionId})
        > {
  $$SavedQuestionsTableTableManager(
    _$AppDatabase db,
    $SavedQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedQuestionsCompanion(
                questionId: questionId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedQuestionsCompanion.insert(
                questionId: questionId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavedQuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({questionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (questionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.questionId,
                                referencedTable: $$SavedQuestionsTableReferences
                                    ._questionIdTable(db),
                                referencedColumn:
                                    $$SavedQuestionsTableReferences
                                        ._questionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SavedQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedQuestionsTable,
      SavedQuestion,
      $$SavedQuestionsTableFilterComposer,
      $$SavedQuestionsTableOrderingComposer,
      $$SavedQuestionsTableAnnotationComposer,
      $$SavedQuestionsTableCreateCompanionBuilder,
      $$SavedQuestionsTableUpdateCompanionBuilder,
      (SavedQuestion, $$SavedQuestionsTableReferences),
      SavedQuestion,
      PrefetchHooks Function({bool questionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$UserProgressTableTableManager get userProgress =>
      $$UserProgressTableTableManager(_db, _db.userProgress);
  $$SavedQuestionsTableTableManager get savedQuestions =>
      $$SavedQuestionsTableTableManager(_db, _db.savedQuestions);
}
