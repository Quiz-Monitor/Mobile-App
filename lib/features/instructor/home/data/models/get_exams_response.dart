import 'package:examify/features/instructor/home/data/models/exam_model.dart';

class GetExamsResponse {
  final String? message;
  final List<ExamModel> exams;

  const GetExamsResponse({this.message, required this.exams});

  factory GetExamsResponse.fromJson(Map<String, dynamic> json) {
    final rawExams = _extractRawExams(json);
    return GetExamsResponse(
      message: json['message']?.toString(),
      exams: rawExams
          .whereType<Map<String, dynamic>>()
          .map(ExamModel.fromJson)
          .toList(),
    );
  }

  static Iterable<dynamic> _extractRawExams(Map<String, dynamic> json) {
    final candidates = <dynamic>[
      json['data'],
      json['exams'],
      json['items'],
      json['result'],
      json['payload'],
    ];

    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate;
      }

      if (candidate is Map<String, dynamic> && _looksLikeExam(candidate)) {
        return <Map<String, dynamic>>[candidate];
      }
    }

    if (_looksLikeExam(json)) {
      return <Map<String, dynamic>>[json];
    }

    return const <dynamic>[];
  }

  static bool _looksLikeExam(Map<String, dynamic> json) {
    return json.containsKey('examId') ||
        json.containsKey('id') ||
        json.containsKey('title') ||
        json.containsKey('startTime') ||
        json.containsKey('startAt');
  }
}
