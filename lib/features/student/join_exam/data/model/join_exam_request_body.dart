class JoinExamRequestBody {
  final String examCode;

  const JoinExamRequestBody({required this.examCode});

  Map<String, dynamic> toJson() => <String, dynamic>{'examCode': examCode};
}
