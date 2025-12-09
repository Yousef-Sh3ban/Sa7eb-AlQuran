// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProgressModel _$UserProgressModelFromJson(Map<String, dynamic> json) =>
    UserProgressModel(
      questionId: json['question_id'] as String,
      status: (json['status'] as num).toInt(),
      attempts: (json['attempts'] as num).toInt(),
      lastAttempt: json['last_attempt'] == null
          ? null
          : DateTime.parse(json['last_attempt'] as String),
    );

Map<String, dynamic> _$UserProgressModelToJson(UserProgressModel instance) =>
    <String, dynamic>{
      'question_id': instance.questionId,
      'status': instance.status,
      'attempts': instance.attempts,
      'last_attempt': instance.lastAttempt?.toIso8601String(),
    };
