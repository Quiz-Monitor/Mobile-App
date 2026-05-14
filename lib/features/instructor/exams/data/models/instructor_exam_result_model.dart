class InstructorExamResultModel {
  final int studentId;
  final String studentName;
  final double finalScore;
  final String cheatingStatus;
  final int totalViolations;

  const InstructorExamResultModel({
    required this.studentId,
    required this.studentName,
    required this.finalScore,
    required this.cheatingStatus,
    required this.totalViolations,
  });

  factory InstructorExamResultModel.fromJson(Map<String, dynamic> json) {
    return InstructorExamResultModel(
      studentId: _readInt(json, const ['studentId', 'id']) ?? 0,
      studentName:
          _readString(json, const ['studentName', 'name']) ?? 'Unknown student',
      finalScore: _readDouble(json, const ['finalScore', 'score']) ?? 0,
      cheatingStatus:
          _readString(json, const ['cheatingStatus', 'status']) ?? 'unknown',
      totalViolations:
          _readInt(json, const ['totalViolations', 'violations']) ?? 0,
    );
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value != null) {
        final parsed = int.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static double? _readDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is double) return value;
      if (value is num) return value.toDouble();
      if (value != null) {
        final parsed = double.tryParse(value.toString());
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }
    return null;
  }
}
