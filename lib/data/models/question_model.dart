import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/question_category.dart';

part 'question_model.g.dart';

/// Question data model.
@JsonSerializable()
class QuestionModel {
  final String id;
  @JsonKey(name: 'surah_id')
  final int surahId;
  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  final QuestionCategory category;
  @JsonKey(name: 'question_text')
  final String questionText;
  final List<String> options;
  @JsonKey(name: 'correct_answer_index')
  final int correctAnswerIndex;
  final String explanation;

  const QuestionModel({
    required this.id,
    required this.surahId,
    required this.category,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);

  static QuestionCategory _categoryFromJson(String value) =>
      QuestionCategory.fromString(value);

  static String _categoryToJson(QuestionCategory category) => category.name;

  String get correctAnswer => options[correctAnswerIndex];
}
