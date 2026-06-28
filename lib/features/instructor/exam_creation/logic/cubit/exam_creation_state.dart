import 'package:flutter/foundation.dart';

@immutable
sealed class ExamCreationState {}

final class ExamCreationInitial extends ExamCreationState {}

final class ExamCreationLoading extends ExamCreationState {}

// When exam is created and we have the ID to add questions
final class ExamCreatedSuccess extends ExamCreationState {
  final int examId;
  ExamCreatedSuccess(this.examId);
}

final class QuestionAdding extends ExamCreationState {}

final class QuestionAddedSuccess extends ExamCreationState {}

final class QuestionUpdating extends ExamCreationState {}

final class QuestionUpdatedSuccess extends ExamCreationState {}

final class ExamPublishing extends ExamCreationState {}

final class ExamPublishedSuccess extends ExamCreationState {}

final class ExamCreationError extends ExamCreationState {
  final String message;
  ExamCreationError(this.message);
}
