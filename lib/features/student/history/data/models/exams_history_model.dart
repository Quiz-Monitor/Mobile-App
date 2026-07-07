class ExamsHistoryModel {
  final String examTitle;
  final String status;
  final String? submitTime;
  final int? finalScore;
  final int? examTotalPoints;

  ExamsHistoryModel({
    required this.examTitle,
    required this.status,
    this.submitTime,
    this.finalScore,
    this.examTotalPoints,
  });

  bool get isPending => status.toLowerCase() != 'graded';

  factory ExamsHistoryModel.fromJson(Map<String, dynamic> json) {
    return ExamsHistoryModel(
      examTitle:
          json['examTitle']?.toString() ??
          json['title']?.toString() ??
          json['examName']?.toString() ??
          'Untitled',
      status:
          json['status']?.toString() ??
          json['examStatus']?.toString() ??
          'Pending',
      submitTime:
          json['submitTime']?.toString() ??
          json['submittedAt']?.toString() ??
          json['completedAt']?.toString(),
      finalScore:
          (json['finalScore'] as num?)?.toInt() ??
          (json['score'] as num?)?.toInt(),
      examTotalPoints:
          (json['examTotalPoints'] as num?)?.toInt() ??
          (json['totalPoints'] as num?)?.toInt() ??
          100,
    );
  }

  Map<String, dynamic> toJson() => {
    'examTitle': examTitle,
    'status': status,
    'submitTime': submitTime,
    'finalScore': finalScore,
    'examTotalPoints': examTotalPoints,
  };
}
