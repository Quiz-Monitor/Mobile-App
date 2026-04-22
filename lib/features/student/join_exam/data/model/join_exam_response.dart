class JoinExamResponse {
  final String? message;
  final JoinedExam? exam;

  const JoinExamResponse({this.message, this.exam});

  factory JoinExamResponse.fromJson(Map<String, dynamic> json) {
    final examJson = json['exam'] ?? json['data'];
    return JoinExamResponse(
      message: json['message']?.toString(),
      exam: examJson is Map<String, dynamic>
          ? JoinedExam.fromJson(examJson)
          : null,
    );
  }
}

class JoinedExam {
  final int? id;
  final String? title;
  final String? description;
  final DateTime? startAt;
  final DateTime? endAt;
  final String? examCode;

  const JoinedExam({
    this.id,
    this.title,
    this.description,
    this.startAt,
    this.endAt,
    this.examCode,
  });

  factory JoinedExam.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String key) {
      final value = json[key]?.toString();
      if (value == null || value.isEmpty) {
        return null;
      }
      return DateTime.tryParse(value);
    }

    return JoinedExam(
      id: json['id'] as int? ?? json['examId'] as int?,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      startAt: parseDate('startAt') ?? parseDate('startDate'),
      endAt: parseDate('endAt') ?? parseDate('endDate'),
      examCode: json['examCode']?.toString() ?? json['code']?.toString(),
    );
  }
}
