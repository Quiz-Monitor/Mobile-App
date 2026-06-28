import 'package:json_annotation/json_annotation.dart';

part 'written_answer_model.g.dart';

@JsonSerializable()
class WrittenAnswerModel {
  @JsonKey(name: 'answerId', readValue: _readAnswerId)
  final int answerId; // Changed to int based on typical usage, fallback to parsing

  final String questionText;
  final String studentAnswerText;

  WrittenAnswerModel({
    required this.answerId,
    required this.questionText,
    required this.studentAnswerText,
  });

  factory WrittenAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$WrittenAnswerModelFromJson(json);

  static dynamic _readAnswerId(Map map, String key) {
    var val = map['answerId'] ?? map['id'];
    if (val is String) return int.tryParse(val) ?? 0;
    if (val is num) return val.toInt();
    return 0;
  }
}

@JsonSerializable()
class GradeRequestBody {
  final double grade;

  GradeRequestBody({required this.grade});

  factory GradeRequestBody.fromJson(Map<String, dynamic> json) =>
      _$GradeRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$GradeRequestBodyToJson(this);
}
