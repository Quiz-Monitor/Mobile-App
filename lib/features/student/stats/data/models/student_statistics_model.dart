class StudentStatisticsModel {
  final OverviewStats overview;
  final ScoreStatistics scoreStatistics;
  final IntegrityStatistics integrityStatistics;
  final TimeStatistics timeStatistics;

  StudentStatisticsModel({
    required this.overview,
    required this.scoreStatistics,
    required this.integrityStatistics,
    required this.timeStatistics,
  });

  factory StudentStatisticsModel.fromJson(Map<String, dynamic> json) {
    return StudentStatisticsModel(
      overview: OverviewStats.fromJson(
        json['overview'] as Map<String, dynamic>? ?? {},
      ),
      scoreStatistics: ScoreStatistics.fromJson(
        json['scoreStatistics'] as Map<String, dynamic>? ?? {},
      ),
      integrityStatistics: IntegrityStatistics.fromJson(
        json['integrityStatistics'] as Map<String, dynamic>? ?? {},
      ),
      timeStatistics: TimeStatistics.fromJson(
        json['timeStatistics'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class OverviewStats {
  final int totalExamsSubmitted;
  final int totalExamsGraded;
  final int totalExamsPendingGrading;

  OverviewStats({
    required this.totalExamsSubmitted,
    required this.totalExamsGraded,
    required this.totalExamsPendingGrading,
  });

  factory OverviewStats.fromJson(Map<String, dynamic> json) {
    return OverviewStats(
      totalExamsSubmitted: (json['totalExamsSubmitted'] as num?)?.toInt() ?? 0,
      totalExamsGraded: (json['totalExamsGraded'] as num?)?.toInt() ?? 0,
      totalExamsPendingGrading:
          (json['totalExamsPendingGrading'] as num?)?.toInt() ?? 0,
    );
  }
}

class ExamHighlight {
  final String examTitle;
  final double scorePercentage;
  final double finalScore;
  final double examTotalPoints;

  ExamHighlight({
    required this.examTitle,
    required this.scorePercentage,
    required this.finalScore,
    required this.examTotalPoints,
  });

  factory ExamHighlight.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ExamHighlight(
        examTitle: 'N/A',
        scorePercentage: 0,
        finalScore: 0,
        examTotalPoints: 0,
      );
    }
    return ExamHighlight(
      examTitle: (json['examTitle'] as String?) ?? 'N/A',
      scorePercentage: (json['scorePercentage'] as num?)?.toDouble() ?? 0,
      finalScore: (json['finalScore'] as num?)?.toDouble() ?? 0,
      examTotalPoints: (json['examTotalPoints'] as num?)?.toDouble() ?? 0,
    );
  }
}

class ScoreStatistics {
  final double averageScorePercentage;
  final double highestScorePercentage;
  final double lowestScorePercentage;
  final ExamHighlight? highestScoringExam;
  final ExamHighlight? lowestScoringExam;

  ScoreStatistics({
    required this.averageScorePercentage,
    required this.highestScorePercentage,
    required this.lowestScorePercentage,
    this.highestScoringExam,
    this.lowestScoringExam,
  });

  factory ScoreStatistics.fromJson(Map<String, dynamic> json) {
    return ScoreStatistics(
      averageScorePercentage:
          (json['averageScorePercentage'] as num?)?.toDouble() ?? 0,
      highestScorePercentage:
          (json['highestScorePercentage'] as num?)?.toDouble() ?? 0,
      lowestScorePercentage:
          (json['lowestScorePercentage'] as num?)?.toDouble() ?? 0,
      highestScoringExam: ExamHighlight.fromJson(
        json['highestScoringExam'] as Map<String, dynamic>?,
      ),
      lowestScoringExam: ExamHighlight.fromJson(
        json['lowestScoringExam'] as Map<String, dynamic>?,
      ),
    );
  }
}

class IntegrityStatistics {
  final int totalViolationsAcrossAllExams;
  final double averageViolationsPerExam;
  final int cleanExams;
  final int warningExams;
  final int flaggedExams;

  IntegrityStatistics({
    required this.totalViolationsAcrossAllExams,
    required this.averageViolationsPerExam,
    required this.cleanExams,
    required this.warningExams,
    required this.flaggedExams,
  });

  factory IntegrityStatistics.fromJson(Map<String, dynamic> json) {
    return IntegrityStatistics(
      totalViolationsAcrossAllExams:
          (json['totalViolationsAcrossAllExams'] as num?)?.toInt() ?? 0,
      averageViolationsPerExam:
          (json['averageViolationsPerExam'] as num?)?.toDouble() ?? 0,
      cleanExams: (json['cleanExams'] as num?)?.toInt() ?? 0,
      warningExams: (json['warningExams'] as num?)?.toInt() ?? 0,
      flaggedExams: (json['flaggedExams'] as num?)?.toInt() ?? 0,
    );
  }
}

class TimeStatistics {
  final int averageTimeSpentSeconds;
  final int totalTimeSpentSeconds;

  TimeStatistics({
    required this.averageTimeSpentSeconds,
    required this.totalTimeSpentSeconds,
  });

  factory TimeStatistics.fromJson(Map<String, dynamic> json) {
    return TimeStatistics(
      averageTimeSpentSeconds:
          (json['averageTimeSpentSeconds'] as num?)?.toInt() ?? 0,
      totalTimeSpentSeconds:
          (json['totalTimeSpentSeconds'] as num?)?.toInt() ?? 0,
    );
  }
}
