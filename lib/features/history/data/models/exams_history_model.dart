class ExamsHistoryModel {
  final String title;
  final String date;
  final bool isPending;
  final int? garade;

  ExamsHistoryModel({
     this.garade,
    required this.title,
    required this.date,
    required this.isPending,
  });
}
