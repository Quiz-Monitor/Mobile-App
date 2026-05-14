import 'package:examify/features/instructor/home/data/repo/instructor_home_repo.dart';

abstract class InstructorHomeState {
  const InstructorHomeState();
}

class InstructorHomeInitial extends InstructorHomeState {
  const InstructorHomeInitial();
}

class InstructorHomeLoading extends InstructorHomeState {
  const InstructorHomeLoading();
}

class InstructorHomeSuccess extends InstructorHomeState {
  final InstructorDashboardDto data;

  const InstructorHomeSuccess(this.data);
}

class InstructorHomeFailure extends InstructorHomeState {
  final String message;

  const InstructorHomeFailure(this.message);
}
