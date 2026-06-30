import 'package:freezed_annotation/freezed_annotation.dart';

part 'exam_model.freezed.dart';
part 'exam_model.g.dart';

class LocalDateTimeConverter implements JsonConverter<DateTime, String> {
  const LocalDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toIso8601String();
}

enum ExamState { draft, live, upcoming, completed }

@freezed
abstract class ExamModel with _$ExamModel {
  const ExamModel._();

  const factory ExamModel({
    required int examId,
    required String title,
    required String description,
    @LocalDateTimeConverter() required DateTime startTime,
    @LocalDateTimeConverter() required DateTime endTime,
    required int durationMinutes,
    required String examCode,
    @Default('') String instructorName,
    @Default(false) bool isPublished,
  }) = _ExamModel;

  factory ExamModel.fromJson(Map<String, dynamic> json) =>
      _$ExamModelFromJson(json);

  bool get isDraft => !isPublished;

  bool get isLive => isPublished && isLiveAt(DateTime.now());

  bool get isUpcoming => isPublished && isUpcomingAt(DateTime.now());

  bool get isCompleted => isPublished && isCompletedAt(DateTime.now());

  bool isLiveAt(DateTime moment) =>
      !moment.isBefore(startTime) && !moment.isAfter(endTime);

  bool isUpcomingAt(DateTime moment) => moment.isBefore(startTime);

  bool isCompletedAt(DateTime moment) => moment.isAfter(endTime);

  ExamState get examState {
    if (!isPublished) return ExamState.draft;
    final now = DateTime.now();
    if (isLiveAt(now)) return ExamState.live;
    if (isUpcomingAt(now)) return ExamState.upcoming;
    return ExamState.completed;
  }
}
