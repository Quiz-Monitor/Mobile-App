import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/data/repo/exam_creation_repo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_question_state.dart';

class AddQuestionCubit extends Cubit<AddQuestionState> {
  final ExamCreationRepo _repo;
  final int examId;

  AddQuestionCubit(this._repo, this.examId) : super(AddQuestionInitial());

  Future<void> addQuestion(
    String text,
    String type,
    int points,
    List<ChoiceDto> choices,
  ) async {
    emit(QuestionAdding());
    final body = AddQuestionRequestBody(
      text: text,
      type: type,
      points: points,
      choices: choices,
    );

    final result = await _repo.addQuestion(examId, body);
    result.when(
      success: (_) {
        emit(QuestionAddedSuccess());
      },
      failure: (error) {
        emit(
          AddQuestionError(
            error.apiErrorModel.message ?? 'Failed to add question',
          ),
        );
      },
    );
  }

  Future<void> publishExam() async {
    emit(ExamPublishing());
    final result = await _repo.publishExam(examId);
    result.when(
      success: (_) {
        emit(ExamPublishedSuccess());
      },
      failure: (error) {
        emit(
          AddQuestionError(
            error.apiErrorModel.message ?? 'Failed to publish exam',
          ),
        );
      },
    );
  }
}
