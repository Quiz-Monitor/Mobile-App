class InstructorStatisticsModel {
  final ExamOverview examOverview;
  final StudentOverview studentOverview;
  final InstructorScoreStatistics scoreStatistics;
  final InstructorIntegrityStatistics integrityStatistics;

  InstructorStatisticsModel({
    required this.examOverview,
    required this.studentOverview,
    required this.scoreStatistics,
    required this.integrityStatistics,
  });

  factory InstructorStatisticsModel.fromJson(Map<String, dynamic> json) {
    return InstructorStatisticsModel(
      examOverview: ExamOverview.fromJson(
        json['examOverview'] as Map<String, dynamic>? ?? {},
      ),
      studentOverview: StudentOverview.fromJson(
        json['studentOverview'] as Map<String, dynamic>? ?? {},
      ),
      scoreStatistics: InstructorScoreStatistics.fromJson(
        json['scoreStatistics'] as Map<String, dynamic>? ?? {},
      ),
      integrityStatistics: InstructorIntegrityStatistics.fromJson(
        json['integrityStatistics'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class ExamOverview {
  final int totalExamsCreated;
  final int totalExamsPublished;
  final int totalExamsDraft;
  final int totalExamsWithAttempts;

  ExamOverview({
    required this.totalExamsCreated,
    required this.totalExamsPublished,
    required this.totalExamsDraft,
    required this.totalExamsWithAttempts,
  });

  factory ExamOverview.fromJson(Map<String, dynamic> json) {
    return ExamOverview(
      totalExamsCreated: (json['totalExamsCreated'] as num?)?.toInt() ?? 0,
      totalExamsPublished: (json['totalExamsPublished'] as num?)?.toInt() ?? 0,
      totalExamsDraft: (json['totalExamsDraft'] as num?)?.toInt() ?? 0,
      totalExamsWithAttempts:
          (json['totalExamsWithAttempts'] as num?)?.toInt() ?? 0,
    );
  }
}

class StudentOverview {
  final int totalUniqueStudents;
  final int totalAttempts;
  final int totalGradedAttempts;
  final int totalPendingGradingAttempts;

  StudentOverview({
    required this.totalUniqueStudents,
    required this.totalAttempts,
    required this.totalGradedAttempts,
    required this.totalPendingGradingAttempts,
  });

  factory StudentOverview.fromJson(Map<String, dynamic> json) {
    return StudentOverview(
      totalUniqueStudents: (json['totalUniqueStudents'] as num?)?.toInt() ?? 0,
      totalAttempts: (json['totalAttempts'] as num?)?.toInt() ?? 0,
      totalGradedAttempts: (json['totalGradedAttempts'] as num?)?.toInt() ?? 0,
      totalPendingGradingAttempts:
          (json['totalPendingGradingAttempts'] as num?)?.toInt() ?? 0,
    );
  }
}

class InstructorExamHighlight {
  final int examId;
  final String examTitle;
  final double averageScorePercentage;
  final int attemptCount;

  InstructorExamHighlight({
    required this.examId,
    required this.examTitle,
    required this.averageScorePercentage,
    required this.attemptCount,
  });

  factory InstructorExamHighlight.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return InstructorExamHighlight(
        examId: 0,
        examTitle: 'N/A',
        averageScorePercentage: 0,
        attemptCount: 0,
      );
    }
    return InstructorExamHighlight(
      examId: (json['examId'] as num?)?.toInt() ?? 0,
      examTitle: (json['examTitle'] as String?) ?? 'N/A',
      averageScorePercentage:
          (json['averageScorePercentage'] as num?)?.toDouble() ?? 0,
      attemptCount: (json['attemptCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class InstructorScoreStatistics {
  final double averageScorePercentage;
  final InstructorExamHighlight? highestAverageExam;
  final InstructorExamHighlight? lowestAverageExam;
  final double passRate;

  InstructorScoreStatistics({
    required this.averageScorePercentage,
    this.highestAverageExam,
    this.lowestAverageExam,
    required this.passRate,
  });

  factory InstructorScoreStatistics.fromJson(Map<String, dynamic> json) {
    return InstructorScoreStatistics(
      averageScorePercentage:
          (json['averageScorePercentage'] as num?)?.toDouble() ?? 0,
      highestAverageExam: InstructorExamHighlight.fromJson(
        json['highestAverageExam'] as Map<String, dynamic>?,
      ),
      lowestAverageExam: InstructorExamHighlight.fromJson(
        json['lowestAverageExam'] as Map<String, dynamic>?,
      ),
      passRate: (json['passRate'] as num?)?.toDouble() ?? 0,
    );
  }
}

class InstructorIntegrityStatistics {
  final int totalViolationsAcrossAllExams;
  final double averageViolationsPerAttempt;
  final int cleanAttempts;
  final int warningAttempts;
  final int flaggedAttempts;

  InstructorIntegrityStatistics({
    required this.totalViolationsAcrossAllExams,
    required this.averageViolationsPerAttempt,
    required this.cleanAttempts,
    required this.warningAttempts,
    required this.flaggedAttempts,
  });

  factory InstructorIntegrityStatistics.fromJson(Map<String, dynamic> json) {
    return InstructorIntegrityStatistics(
      totalViolationsAcrossAllExams:
          (json['totalViolationsAcrossAllExams'] as num?)?.toInt() ?? 0,
      averageViolationsPerAttempt:
          (json['averageViolationsPerAttempt'] as num?)?.toDouble() ?? 0,
      cleanAttempts: (json['cleanAttempts'] as num?)?.toInt() ?? 0,
      warningAttempts: (json['warningAttempts'] as num?)?.toInt() ?? 0,
      flaggedAttempts: (json['flaggedAttempts'] as num?)?.toInt() ?? 0,
    );
  }
}
