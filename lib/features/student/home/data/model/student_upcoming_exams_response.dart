import 'package:examify/features/student/home/data/model/student_exam_model.dart';

class StudentUpcomingExamsResponse {
  final List<StudentExamModel> exams;

  const StudentUpcomingExamsResponse({required this.exams});

  factory StudentUpcomingExamsResponse.fromResponse(dynamic response) {
    final rawExams = _extractRawExams(response);
    final exams = rawExams
        .where((exam) => exam is Map<String, dynamic>)
        .map((exam) => StudentExamModel.fromJson(exam as Map<String, dynamic>))
        .toList();
    return StudentUpcomingExamsResponse(exams: exams);
  }

  static Iterable<dynamic> _extractRawExams(dynamic response) {
    if (response == null) {
      return const <dynamic>[];
    }

    if (response is List) {
      return response;
    }

    if (response is Map<String, dynamic>) {
      final candidates = <dynamic>[
        response['data'],
        response['exams'],
        response['items'],
        response['result'],
        response['payload'],
      ];

      for (final candidate in candidates) {
        if (candidate is List) {
          return candidate;
        }

        if (candidate is Map<String, dynamic> && _looksLikeExam(candidate)) {
          return <Map<String, dynamic>>[candidate];
        }
      }

      if (_looksLikeExam(response)) {
        return <Map<String, dynamic>>[response];
      }
    }

    return const <dynamic>[];
  }

  static bool _looksLikeExam(Map<String, dynamic> json) {
    return json.containsKey('examTitle') ||
        json.containsKey('examCode') ||
        json.containsKey('startTime') ||
        json.containsKey('startAt');
  }
}
