import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';

class StudentStatsRepo {
  final ApiService _apiService;

  StudentStatsRepo(this._apiService);

  Future<ApiResult<StudentStatisticsModel>> getStudentStatistics() async {
    try {
      final response = await _apiService.getStudentStatistics();
      final model = StudentStatisticsModel.fromJson(
        response as Map<String, dynamic>,
      );
      return ApiResult.success(model);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
