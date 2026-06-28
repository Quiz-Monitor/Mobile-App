import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/grading/data/models/written_answer_model.dart';
import 'package:examify/features/instructor/grading/data/repo/grading_repo.dart';
import 'package:examify/features/instructor/grading/logic/cubit/grading_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GradingCubit extends Cubit<GradingState> {
  final GradingRepo _repo;
  List<WrittenAnswerModel> _currentAnswers = [];

  GradingCubit(this._repo) : super(GradingInitial());

  Future<void> loadAnswers(int examId, int studentId) async {
    emit(GradingLoading());
    final result = await _repo.getWrittenAnswers(examId, studentId);
    result.when(
      success: (answers) {
        _currentAnswers = answers;
        emit(GradingLoaded(_currentAnswers));
      },
      failure: (error) {
        emit(
          GradingError(error.apiErrorModel.message ?? 'Failed to load answers'),
        );
      },
    );
  }

  Future<void> submitGrade(int answerId, double grade) async {
    emit(GradingAnswerSubmitting(answerId));
    final result = await _repo.gradeAnswer(answerId, grade);
    result.when(
      success: (_) {
        emit(GradingAnswerSuccess(answerId));
        // Restore loaded state so UI shows the list normally again
        emit(GradingLoaded(_currentAnswers));
      },
      failure: (error) {
        emit(
          GradingError(error.apiErrorModel.message ?? 'Failed to submit grade'),
        );
        emit(GradingLoaded(_currentAnswers));
      },
    );
  }
}
