import 'package:examify/features/instructor/home/data/models/exam_model.dart';

abstract class ExamsState {
  const ExamsState();
}

class ExamsInitial extends ExamsState {
  const ExamsInitial();
}

class ExamsLoading extends ExamsState {
  const ExamsLoading();
}

class ExamsSuccess extends ExamsState {
  final List<ExamModel> exams;

  const ExamsSuccess(this.exams);
}

class ExamsFailure extends ExamsState {
  final String message;

  const ExamsFailure(this.message);
}
