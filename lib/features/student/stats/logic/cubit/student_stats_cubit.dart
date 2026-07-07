import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/stats/data/repo/student_stats_repo.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_state.dart';

class StudentStatsCubit extends Cubit<StudentStatsState> {
  final StudentStatsRepo _repo;

  StudentStatsCubit(this._repo) : super(StudentStatsInitial());

  Future<void> getStatistics() async {
    emit(StudentStatsLoading());
    final result = await _repo.getStudentStatistics();
    result.when(
      success: (stats) => emit(StudentStatsSuccess(stats)),
      failure: (error) =>
          emit(StudentStatsFailure(error.apiErrorModel.getAllErrorMessages())),
    );
  }
}
