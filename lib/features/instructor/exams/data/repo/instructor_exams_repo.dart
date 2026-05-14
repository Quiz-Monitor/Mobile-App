import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
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
}
