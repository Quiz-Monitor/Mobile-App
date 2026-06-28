part of 'add_question_cubit.dart';

@immutable
sealed class AddQuestionState {}

final class AddQuestionInitial extends AddQuestionState {}

final class QuestionAdding extends AddQuestionState {}

final class QuestionAddedSuccess extends AddQuestionState {}

final class ExamPublishing extends AddQuestionState {}

final class ExamPublishedSuccess extends AddQuestionState {}

final class AddQuestionError extends AddQuestionState {
  final String message;
  AddQuestionError(this.message);
}
