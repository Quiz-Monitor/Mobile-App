import 'package:examify/features/student/home/data/model/student_exam_model.dart';

abstract class StudentExamState {
  const StudentExamState();
}

class StudentExamInitial extends StudentExamState {
  const StudentExamInitial();
}

class StudentExamLoading extends StudentExamState {
  const StudentExamLoading();
}

class StudentExamSuccess extends StudentExamState {
  final List<StudentExamModel> exams;

  const StudentExamSuccess(this.exams);
}

class StudentExamEmpty extends StudentExamState {
  const StudentExamEmpty();
}

class StudentExamFailure extends StudentExamState {
  final String message;

  const StudentExamFailure(this.message);
}
