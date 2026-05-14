import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';

class InstructorExamsRepo {
  final ApiService _apiService;

  InstructorExamsRepo(this._apiService);

  Future<ApiResult<List<ExamModel>>> getInstructorExams() async {
    try {
      final response = await _apiService.getExams();
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<InstructorExamResultModel>>> getExamResults(
    int examId,
  ) async {
    try {
      final response = await _apiService.getExamResults(examId);
      return ApiResult.success(response);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<int>> getEnrolledStudentsCount(int examId) async {
    final result = await getExamResults(examId);
    return result.when(
      success: (rows) => ApiResult.success(rows.length),
      failure: (error) => ApiResult.failure(error),
    );
  }
}
