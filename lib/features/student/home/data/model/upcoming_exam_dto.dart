class UpcomingExamDto {
  final int id;
  final String title;
  final String time;
  final int participants;
  final String daysLeft;

  const UpcomingExamDto({
    required this.id,
    required this.title,
    required this.time,
    required this.participants,
    required this.daysLeft,
  });
}
