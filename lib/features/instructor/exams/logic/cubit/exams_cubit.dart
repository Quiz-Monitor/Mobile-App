import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';

import 'exams_state.dart';

class ExamsCubit extends Cubit<ExamsState> {
  final InstructorExamsRepo _instructorExamsRepo;

  ExamsCubit(this._instructorExamsRepo) : super(const ExamsState.initial());

  Future<void> getInstructorExams({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ExamsState.loading());
    }

    final result = await _instructorExamsRepo.getInstructorExams();

    result.when(
      success: (exams) async {
        final enrolledCounts = await _loadEnrolledCounts(exams);
        emit(ExamsState.success(exams: exams, enrolledCounts: enrolledCounts));
      },
      failure: (error) {
        emit(ExamsState.failure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }

  Future<Map<int, int>> _loadEnrolledCounts(List<ExamModel> exams) async {
    final entries = await Future.wait(
      exams.map((exam) async {
        final countResult = await _instructorExamsRepo.getEnrolledStudentsCount(
          exam.examId,
        );

        final count = countResult.when(
          success: (value) => value,
          failure: (_) => 0,
        );

        return MapEntry(exam.examId, count);
      }),
    );

    return Map<int, int>.fromEntries(entries);
  }
}
