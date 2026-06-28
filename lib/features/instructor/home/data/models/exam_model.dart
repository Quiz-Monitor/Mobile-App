import 'package:json_annotation/json_annotation.dart';

part 'exam_model.g.dart';

@JsonSerializable()
class ExamModel {
  int examId;
  String title;
  String description;

  @JsonKey(fromJson: _parseDateTime)
  DateTime startTime;

  @JsonKey(fromJson: _parseDateTime)
  DateTime endTime;

  int durationMinutes;
  String examCode;

  @JsonKey(defaultValue: '')
  String instructorName;

  @JsonKey(defaultValue: false)
  bool isPublished;

  ExamModel({
    required this.examId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.examCode,
    this.instructorName = '',
    this.isPublished = false,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) =>
      _$ExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamModelToJson(this);

  static DateTime _parseDateTime(String value) {
    return DateTime.parse(value).toLocal();
  }

  bool get isLive => isLiveAt(DateTime.now());

  bool get isUpcoming => isUpcomingAt(DateTime.now());

  bool get isCompleted => isCompletedAt(DateTime.now());

  bool isLiveAt(DateTime moment) {
    return !moment.isBefore(startTime) && !moment.isAfter(endTime);
  }

  bool isUpcomingAt(DateTime moment) {
    return moment.isBefore(startTime);
  }

  bool isCompletedAt(DateTime moment) {
    return moment.isAfter(endTime);
  }
}
