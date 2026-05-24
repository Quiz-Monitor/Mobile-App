import 'package:examify/features/student/history/data/models/exams_history_model.dart';

abstract class StudentResultsState {
  const StudentResultsState();
}

class StudentResultsInitial extends StudentResultsState {
  const StudentResultsInitial();
}

class StudentResultsLoading extends StudentResultsState {
  const StudentResultsLoading();
}

class StudentResultsSuccess extends StudentResultsState {
  final List<ExamsHistoryModel> exams;

  const StudentResultsSuccess(this.exams);
}

class StudentResultsEmpty extends StudentResultsState {
  const StudentResultsEmpty();
}

class StudentResultsFailure extends StudentResultsState {
  final String message;

  const StudentResultsFailure(this.message);
}
