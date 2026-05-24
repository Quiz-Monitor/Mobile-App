import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/history/data/repo/student_history_repo.dart';
import 'package:examify/features/student/history/logic/cubit/student_results_state.dart';

class StudentResultsCubit extends Cubit<StudentResultsState> {
  final StudentHistoryRepo _historyRepo;

  StudentResultsCubit(this._historyRepo) : super(const StudentResultsInitial());

  Future<void> getExamHistory() async {
    emit(const StudentResultsLoading());

    final result = await _historyRepo.getExamHistory();
    result.when(
      success: (exams) {
        if (exams.isEmpty) {
          emit(const StudentResultsEmpty());
        } else {
          emit(StudentResultsSuccess(exams));
        }
      },
      failure: (error) {
        emit(StudentResultsFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }
}
