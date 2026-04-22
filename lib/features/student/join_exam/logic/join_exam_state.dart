import 'package:examify/features/student/join_exam/data/model/join_exam_response.dart';

abstract class JoinExamState {
  const JoinExamState();
}

class JoinExamInitial extends JoinExamState {
  const JoinExamInitial();
}

class JoinExamLoading extends JoinExamState {
  const JoinExamLoading();
}

class JoinExamSuccess extends JoinExamState {
  final JoinExamResponse response;

  const JoinExamSuccess(this.response);
}

class JoinExamFailure extends JoinExamState {
  final String message;

  const JoinExamFailure(this.message);
}
