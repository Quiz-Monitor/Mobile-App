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
    required this.endTime ,
    required this.durationMinutes,
    required this.questionCount ,
    required this.examStatus,
  });

  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    final startTime = _readDateTime(json, const ['startTime', 'startAt']) ??
        DateTime.now();
    final durationMinutes =
        _readInt(json, const ['durationMinutes', 'duration']) ?? 60;
    final endTime = _readDateTime(json, const ['endTime', 'endAt']) ??
        startTime.add(Duration(minutes: durationMinutes));
    final examStatus =
        _readString(json, const ['examStatus', 'status']) ?? 'upcoming';
    final isLive = _readBool(json, const ['isLive', 'live']) ??
        examStatus.toLowerCase() == 'live';

    final title = _readString(json, const ['examTitle', 'title', 'name']) ??
        'Untitled exam';

    return StudentExamModel(
      examTitle: title,
      instructorName: _readString(json, const ['instructorName', 'professor']) ??
          '',
      examCode: _readString(json, const ['examCode', 'code']) ??
          _buildFallbackExamCode(title, startTime),
      isLive: isLive,
      startTime: startTime,
      endTime: endTime,
      durationMinutes: durationMinutes,
      questionCount: _readInt(json, const ['questionCount', 'questions']) ?? 0,
      examStatus: examStatus,
    );
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        final stringValue = value.toString().trim();
        if (stringValue.isNotEmpty) {
          return stringValue;
        }
      }
    }
    return null;
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
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }

  static bool? _readBool(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is bool) {
        return value;
      }
      if (value is String) {
        final normalized = value.toLowerCase();
        if (normalized == 'true') {
          return true;
        }
        if (normalized == 'false') {
          return false;
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
      if (value is String) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }

  static String _buildFallbackExamCode(String title, DateTime startTime) {
    final words = title.split(' ').where((w) => w.trim().isNotEmpty).toList();
    final prefix = words.isEmpty
        ? 'EX'
        : words.take(2).map((w) => w.substring(0, 1).toUpperCase()).join();
    return '$prefix${startTime.year}';
  }
}
