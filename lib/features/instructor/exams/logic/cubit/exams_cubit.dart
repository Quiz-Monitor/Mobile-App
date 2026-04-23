import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';

import 'exams_state.dart';

class ExamsCubit extends Cubit<ExamsState> {
  final InstructorExamsRepo _instructorExamsRepo;

  ExamsCubit(this._instructorExamsRepo) : super(const ExamsInitial());

  Future<void> getInstructorExams({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ExamsLoading());
    }

    final ApiResult<List<ExamModel>> result = await _instructorExamsRepo
        .getInstructorExams();
    result.when(
      success: (exams) {
        emit(ExamsSuccess(exams));
      },
      failure: (error) {
        emit(ExamsFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }
}
