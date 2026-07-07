import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:flutter/foundation.dart';

class StudentUpcomingExamsResponse {
  final List<StudentExamModel> exams;

  const StudentUpcomingExamsResponse({required this.exams});

  factory StudentUpcomingExamsResponse.fromResponse(dynamic response) {
    debugPrint(
      '[UpcomingExamsResponse] Response type: ${response.runtimeType}',
    );
    final rawExams = _extractRawExams(response);
    debugPrint(
      '[UpcomingExamsResponse] Raw exams extracted: ${rawExams.length}',
    );
    final exams = rawExams
        .whereType<Map<String, dynamic>>()
        .map((exam) => StudentExamModel.fromJson(exam))
        .toList();
    debugPrint('[UpcomingExamsResponse] Parsed models count: ${exams.length}');
    return StudentUpcomingExamsResponse(exams: exams);
  }

  static Iterable<dynamic> _extractRawExams(dynamic response) {
    if (response == null) {
      debugPrint('[UpcomingExamsResponse] Response is null');
      return const <dynamic>[];
    }

    if (response is List) {
      debugPrint(
        '[UpcomingExamsResponse] Response is a direct List (length: ${response.length})',
      );
      return response;
    }

    if (response is Map<String, dynamic>) {
      debugPrint(
        '[UpcomingExamsResponse] Response is a Map with keys: ${response.keys.toList()}',
      );

      // Check well-known wrapper keys first
      final candidates = <dynamic>[
        response['data'],
        response['exams'],
        response['items'],
        response['result'],
        response['results'],
        response['content'],
        response['payload'],
        response['\$values'],
        response['records'],
        response['list'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          debugPrint(
            '[UpcomingExamsResponse] Found list under a known key (length: ${candidate.length})',
          );
          return candidate;
        }

        if (candidate is Map<String, dynamic> && _looksLikeExam(candidate)) {
          return <Map<String, dynamic>>[candidate];
        }
      }

      // Fallback: scan all values for any List that contains exam-like maps
      for (final entry in response.entries) {
        if (entry.value is List) {
          final list = entry.value as List;
          debugPrint(
            '[UpcomingExamsResponse] Fallback: found list under key "${entry.key}" (length: ${list.length})',
          );
          if (list.isNotEmpty && list.first is Map<String, dynamic>) {
            return list;
          }
        }
      }

      if (_looksLikeExam(response)) {
        debugPrint(
          '[UpcomingExamsResponse] Response itself looks like a single exam',
        );
        return <Map<String, dynamic>>[response];
      }
    }

    debugPrint('[UpcomingExamsResponse] Could not extract exams from response');
    return const <dynamic>[];
  }

  static bool _looksLikeExam(Map<String, dynamic> json) {
    return json.containsKey('examTitle') ||
        json.containsKey('title') ||
        json.containsKey('examCode') ||
        json.containsKey('code') ||
        json.containsKey('startTime') ||
        json.containsKey('startAt');
  }
}
