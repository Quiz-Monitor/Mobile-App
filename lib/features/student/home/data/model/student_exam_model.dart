import 'package:json_annotation/json_annotation.dart';
part 'student_exam_model.g.dart';

@JsonSerializable()
class StudentExamModel {
  final String examTitle, instructorName, examCode;
  final bool isLive;
  final DateTime startTime, endTime;
  final int durationMinutes;
  final int questionCount;
  final String examStatus;

  StudentExamModel({
    required this.examTitle,
    required this.instructorName,
    required this.examCode,
    required this.isLive,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.questionCount,
    required this.examStatus,
  });

  factory StudentExamModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamModelFromJson(json);
}
