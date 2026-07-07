import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/stats/data/repo/instructor_stats_repo.dart';
import 'package:examify/features/instructor/stats/logic/cubit/instructor_stats_state.dart';

class InstructorStatsCubit extends Cubit<InstructorStatsState> {
  final InstructorStatsRepo _repo;

  InstructorStatsCubit(this._repo) : super(InstructorStatsInitial());

  Future<void> getStatistics() async {
    emit(InstructorStatsLoading());
    final result = await _repo.getInstructorStatistics();
    result.when(
      success: (stats) => emit(InstructorStatsSuccess(stats)),
      failure: (error) => emit(
        InstructorStatsFailure(error.apiErrorModel.getAllErrorMessages()),
      ),
    );
  }
}
