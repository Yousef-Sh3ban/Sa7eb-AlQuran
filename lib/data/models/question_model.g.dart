// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      id: json['id'] as String,
      surahId: (json['surah_id'] as num).toInt(),
      category: QuestionModel._categoryFromJson(json['category'] as String),
      questionText: json['question_text'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      correctAnswerIndex: (json['correct_answer_index'] as num).toInt(),
      explanation: json['explanation'] as String,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surah_id': instance.surahId,
      'category': QuestionModel._categoryToJson(instance.category),
      'question_text': instance.questionText,
      'options': instance.options,
      'correct_answer_index': instance.correctAnswerIndex,
      'explanation': instance.explanation,
    };
