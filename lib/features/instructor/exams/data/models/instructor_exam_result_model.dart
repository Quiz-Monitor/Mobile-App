import 'package:json_annotation/json_annotation.dart';

part 'instructor_exam_result_model.g.dart';

@JsonSerializable()
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

  factory InstructorExamResultModel.fromJson(Map<String, dynamic> json) =>
      _$InstructorExamResultModelFromJson(json);

  Map<String, dynamic> toJson() => _$InstructorExamResultModelToJson(this);

  String get normalizedCheatingStatus => cheatingStatus.trim().toLowerCase();

  bool get hasViolations => totalViolations > 0;

  bool get isClean => totalViolations == 0;

  bool get isSuspicious {
    final status = normalizedCheatingStatus;
    return hasViolations ||
        status == 'cheating' ||
        status == 'flagged' ||
        status == 'suspicious' ||
        status == 'violated';
  }

  String get displayStudentName =>
      studentName.trim().isEmpty ? 'Unknown student' : studentName.trim();

  String get displayCheatingStatus {
    final status = cheatingStatus.trim();
    return status.isEmpty ? 'unknown' : status;
  }

  String get scoreLabel => '${finalScore.toStringAsFixed(0)}%';

  String get violationsLabel =>
      totalViolations == 1 ? '1 violation' : '$totalViolations violations';

  InstructorExamResultModel copyWith({
    int? studentId,
    String? studentName,
    double? finalScore,
    String? cheatingStatus,
    int? totalViolations,
  }) {
    return InstructorExamResultModel(
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      finalScore: finalScore ?? this.finalScore,
      cheatingStatus: cheatingStatus ?? this.cheatingStatus,
      totalViolations: totalViolations ?? this.totalViolations,
    );
  }

  @override
  String toString() {
    return 'InstructorExamResultModel(studentId: $studentId, studentName: $studentName, finalScore: $finalScore, cheatingStatus: $cheatingStatus, totalViolations: $totalViolations)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InstructorExamResultModel &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.finalScore == finalScore &&
        other.cheatingStatus == cheatingStatus &&
        other.totalViolations == totalViolations;
  }

  @override
  int get hashCode {
    return Object.hash(
      studentId,
      studentName,
      finalScore,
      cheatingStatus,
      totalViolations,
    );
  }
}
