import 'package:json_annotation/json_annotation.dart';
part 'student_exam_model.g.dart';

@JsonSerializable()
class StudentExamModel {
  final int examId;
  final String examTitle, instructorName, examCode, examStatus;
  @JsonKey(fromJson: _parseDateTime)
  final DateTime startTime;

  @JsonKey(fromJson: _parseDateTime)
  final DateTime endTime;

  final int durationMinutes;
  final int questionCount;

  static DateTime _parseDateTime(dynamic value) {
    if (value is DateTime) return value.isUtc ? value.toLocal() : value;
    String strValue = value.toString();
    if (!strValue.contains('Z') &&
        !strValue.contains('+') &&
        !strValue.contains(RegExp(r'-\d{2}:\d{2}'))) {
      strValue += 'Z';
    }
    return DateTime.parse(strValue).toLocal();
  }

  const StudentExamModel({
    required this.examId,
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
  bool get isLive {
    final now = DateTime.now();
    return examStatus.toLowerCase() == 'live' ||
        examStatus.toLowerCase() == 'inprogress' ||
        (startTime.isBefore(now) && endTime.isAfter(now));
  }

  factory StudentExamModel.fromJson(Map<String, dynamic> json) =>
      _$StudentExamModelFromJson(json);
}
