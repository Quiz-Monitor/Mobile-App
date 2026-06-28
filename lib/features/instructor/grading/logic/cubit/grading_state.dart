import 'package:examify/features/instructor/grading/data/models/written_answer_model.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class GradingState {}

final class GradingInitial extends GradingState {}

final class GradingLoading extends GradingState {}

final class GradingLoaded extends GradingState {
  final List<WrittenAnswerModel> answers;
  GradingLoaded(this.answers);
}

final class GradingAnswerSubmitting extends GradingState {
  final int answerId;
  GradingAnswerSubmitting(this.answerId);
}

final class GradingAnswerSuccess extends GradingState {
  final int answerId;
  GradingAnswerSuccess(this.answerId);
}

final class GradingError extends GradingState {
  final String message;
  GradingError(this.message);
}
