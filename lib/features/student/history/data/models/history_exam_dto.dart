class HistoryExamDto {
  final int id;
  final String title;
  final String date;
  final bool isPending;
  final int? grade;

  const HistoryExamDto({
    required this.id,
    required this.title,
    required this.date,
    required this.isPending,
    this.grade,
  });
}
