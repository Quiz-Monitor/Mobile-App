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

    List<ExamModel>? exams;
    String? errorMessage;

    result.when(
      success: (value) {
        exams = value;
      },
      failure: (error) {
        errorMessage = error.apiErrorModel.getAllErrorMessages();
      },
    );

    if (errorMessage != null) {
      emit(ExamsFailure(errorMessage!));
      return;
    }

    final loadedExams = exams ?? const <ExamModel>[];
    final enrolledCounts = <int, int>{};

    await Future.wait(
      loadedExams.map((exam) async {
        final countResult = await _instructorExamsRepo.getEnrolledStudentsCount(
          exam.examId,
        );

        countResult.when(
          success: (count) {
            enrolledCounts[exam.examId] = count;
          },
          failure: (_) {
            enrolledCounts[exam.examId] = 0;
          },
        );
      }),
    );

    emit(ExamsSuccess(loadedExams, enrolledCounts: enrolledCounts));
  }
}
