import 'package:json_annotation/json_annotation.dart';

part 'exam_model.g.dart';

@JsonSerializable()
class ExamModel {
  int examId;
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;
  String durationMinutes;
  String examCode;
  String instructorName;
  ExamModel({
    required this.examId,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    required this.examCode,
    this.instructorName = '',
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    final startTime =
        _readDateTime(json, const ['startTime', 'startAt']) ?? DateTime.now();
    final durationMinutes =
        _readString(json, const ['durationMinutes', 'duration']) ?? '60';
    final parsedDuration = int.tryParse(durationMinutes) ?? 60;
    final endTime =
        _readDateTime(json, const ['endTime', 'endAt']) ??
        startTime.add(Duration(minutes: parsedDuration));

    final title = _readString(json, const ['title', 'name']) ?? 'Untitled exam';

    return ExamModel(
      examId: _readInt(json, const ['examId', 'id']) ?? 0,
      title: title,
      description: _readString(json, const ['description', 'details']) ?? '',
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      examCode:
          _readString(json, const ['examCode', 'code']) ??
          _buildFallbackExamCode(title, startTime),
      instructorName:
          _readString(json, const [
            'instructorName',
            'professorName',
            'professor',
            'teacherName',
            'ownerName',
            'createdByName',
          ]) ??
          '',
    );
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

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) {
        return value;
      }
      if (value is num) {
        return value.toInt();
      }
      if (value != null) {
        return int.tryParse(value.toString());
      }
    }
    return null;
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty) {
          return text;
        }
      }
    }
    return null;
  }

  static DateTime? _readDateTime(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is DateTime) {
        return value;
      }
      if (value != null) {
        return DateTime.tryParse(value.toString());
      }
    }
    return null;
  }

  static String _buildFallbackExamCode(String title, DateTime startTime) {
    final words = title
        .split(RegExp(r'\s+'))
        .where((word) => word.trim().isNotEmpty)
        .toList();
    final prefix = words.isEmpty
        ? 'EX'
        : words.take(2).map((word) => word[0].toUpperCase()).join();
    return '$prefix${startTime.year}';
  }
}
