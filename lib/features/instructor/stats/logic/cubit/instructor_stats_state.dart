import 'package:examify/features/instructor/stats/data/models/instructor_statistics_model.dart';

abstract class InstructorStatsState {}

class InstructorStatsInitial extends InstructorStatsState {}

class InstructorStatsLoading extends InstructorStatsState {}

class InstructorStatsSuccess extends InstructorStatsState {
  final InstructorStatisticsModel stats;
  InstructorStatsSuccess(this.stats);
}

class InstructorStatsFailure extends InstructorStatsState {
  final String errorMessage;
  InstructorStatsFailure(this.errorMessage);
}
