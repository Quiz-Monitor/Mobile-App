// Model for Student Exams

class StudentExamModel {
  final int examId;
  final String examTitle, instructorName, examCode, examStatus;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final int questionCount;

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
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

  factory StudentExamModel.fromJson(Map<String, dynamic> json) {
    return StudentExamModel(
      examId:
          (json['examId'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      examTitle:
          json['examTitle']?.toString() ??
          json['title']?.toString() ??
          'Untitled Exam',
      instructorName:
          json['instructorName']?.toString() ??
          json['instructor']?.toString() ??
          'Instructor',
      examCode: json['examCode']?.toString() ?? json['code']?.toString() ?? '',
      examStatus:
          json['examStatus']?.toString() ??
          json['status']?.toString() ??
          (json['isPublished'] == true ? 'Published' : 'Draft'),
      startTime: _parseDateTime(
        json['startTime'] ?? json['startAt'] ?? json['createdAt'],
      ),
      endTime: _parseDateTime(json['endTime'] ?? json['endAt']),
      durationMinutes:
          (json['durationMinutes'] as num?)?.toInt() ??
          (json['duration'] as num?)?.toInt() ??
          60,
      questionCount:
          (json['questionCount'] as num?)?.toInt() ??
          (json['questionsCount'] as num?)?.toInt() ??
          0,
    );
  }
}
