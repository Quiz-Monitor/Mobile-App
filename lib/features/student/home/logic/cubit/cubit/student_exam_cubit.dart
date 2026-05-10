import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/home/data/repo/student_upcoming_exams_repo.dart';

import 'student_exam_state.dart';

class StudentExamCubit extends Cubit<StudentExamState> {
  final StudentUpcomingExamsRepo _repo;

  StudentExamCubit(this._repo) : super(const StudentExamInitial());

  Future<void> getUpcomingExams({bool showLoading = true}) async {
    if (showLoading) {
      emit(const StudentExamLoading());
    }

    final result = await _repo.getUpcomingExams();
    result.when(
      success: (exams) {
        if (exams.isEmpty) {
          emit(const StudentExamEmpty());
        } else {
          emit(StudentExamSuccess(exams));
        }
      },
      failure: (error) {
        emit(StudentExamFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }
}
