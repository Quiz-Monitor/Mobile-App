import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/grading/data/models/written_answer_model.dart';

class GradingRepo {
  final ApiService _apiService;

  GradingRepo(this._apiService);

  Future<ApiResult<List<WrittenAnswerModel>>> getWrittenAnswers(
    int examId,
    int studentId,
  ) async {
    try {
      final response = await _apiService.getWrittenAnswers(examId, studentId);
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> gradeAnswer(int answerId, double grade) async {
    try {
      await _apiService.gradeAnswer(answerId, GradeRequestBody(grade: grade));
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
