import 'package:json_annotation/json_annotation.dart';

part 'user_progress_model.g.dart';

/// User progress data model.
///
/// Status: 0 = new/unsolved, 1 = solved incorrectly, 2 = solved correctly
@JsonSerializable()
class UserProgressModel {
  @JsonKey(name: 'question_id')
  final String questionId;
  final int status;
  final int attempts;
  @JsonKey(name: 'last_attempt')
  final DateTime? lastAttempt;

  const UserProgressModel({
    required this.questionId,
    required this.status,
    required this.attempts,
    this.lastAttempt,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) =>
      _$UserProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProgressModelToJson(this);

  bool get isCorrect => status == 2;
  bool get isIncorrect => status == 1;
  bool get isNew => status == 0;

  UserProgressModel copyWith({
    String? questionId,
    int? status,
    int? attempts,
    DateTime? lastAttempt,
  }) {
    return UserProgressModel(
      questionId: questionId ?? this.questionId,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastAttempt: lastAttempt ?? this.lastAttempt,
    );
  }
}
