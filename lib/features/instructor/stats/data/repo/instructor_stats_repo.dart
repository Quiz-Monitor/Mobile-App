import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/stats/data/models/instructor_statistics_model.dart';

class InstructorStatsRepo {
  final ApiService _apiService;

  InstructorStatsRepo(this._apiService);

  Future<ApiResult<InstructorStatisticsModel>> getInstructorStatistics() async {
    try {
      final rawResponse = await _apiService.getInstructorStats();
      Map<String, dynamic> json;
      if (rawResponse is Map<String, dynamic>) {
        json = rawResponse;
      } else {
        return ApiResult.failure(
          ErrorHandler.handle(Exception('Unexpected response format')),
        );
      }
      final model = InstructorStatisticsModel.fromJson(json);
      return ApiResult.success(model);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
