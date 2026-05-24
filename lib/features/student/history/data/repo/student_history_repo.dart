import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/student/history/data/models/exams_history_model.dart';

class StudentHistoryRepo {
  final ApiService _apiService;

  StudentHistoryRepo(this._apiService);

  Future<ApiResult<List<ExamsHistoryModel>>> getExamHistory() async {
    try {
      final response = await _apiService.getStudentExamHistory();
      final list = (response as List)
          .map((e) => ExamsHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
