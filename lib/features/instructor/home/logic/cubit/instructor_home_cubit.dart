import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/home/data/repo/instructor_home_repo.dart';
import 'package:examify/features/instructor/home/logic/cubit/instructor_home_state.dart';

class InstructorHomeCubit extends Cubit<InstructorHomeState> {
  final InstructorHomeRepo _repo;

  InstructorHomeCubit(this._repo) : super(const InstructorHomeInitial());

  Future<void> getDashboard({bool showLoading = true}) async {
    if (showLoading) {
      emit(const InstructorHomeLoading());
    }

    final result = await _repo.getDashboard();

    result.when(
      success: (data) {
        emit(InstructorHomeSuccess(data));
      },
      failure: (error) {
        emit(InstructorHomeFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }
}
