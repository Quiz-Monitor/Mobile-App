import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';

abstract class StudentStatsState {}

class StudentStatsInitial extends StudentStatsState {}

class StudentStatsLoading extends StudentStatsState {}

class StudentStatsSuccess extends StudentStatsState {
  final StudentStatisticsModel stats;
  StudentStatsSuccess(this.stats);
}

class StudentStatsFailure extends StudentStatsState {
  final String errorMessage;
  StudentStatsFailure(this.errorMessage);
}
