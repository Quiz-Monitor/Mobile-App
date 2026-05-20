import 'package:json_annotation/json_annotation.dart';
part 'student_exam_model.g.dart';

@JsonSerializable()
class StudentExamModel {
  final String examTitle, instructorName, examCode, examStatus;
  final DateTime startTime, endTime;
  final int durationMinutes;
  final int questionCount;

  const StudentExamModel({
    required this.examTitle,
    required this.instructorName,
    required this.examCode,
    required this.examStatus,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.questionCount,
  });

  /// Derived from [examStatus]. The API returns "Live" when the exam is active.
  bool get isLive =>
      examStatus.toLowerCase() == 'live' ||
      examStatus.toLowerCase() == 'inprogress';

  factory StudentExamModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamModelFromJson(json);
}
