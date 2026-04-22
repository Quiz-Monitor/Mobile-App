import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/join_exam/data/repo/join_exam_repo.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_state.dart';

class JoinExamCubit extends Cubit<JoinExamState> {
  final JoinExamRepo _joinExamRepo;

  JoinExamCubit(this._joinExamRepo) : super(const JoinExamInitial());

  Future<void> joinExam(String examCode) async {
    final trimmedExamCode = examCode.trim();

    if (trimmedExamCode.isEmpty) {
      emit(const JoinExamFailure('Exam code is required.'));
      return;
    }

    emit(const JoinExamLoading());

    final result = await _joinExamRepo.joinExam(trimmedExamCode);
    result.when(
      success: (response) {
        emit(JoinExamSuccess(response));
      },
      failure: (error) {
        emit(JoinExamFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }
}
