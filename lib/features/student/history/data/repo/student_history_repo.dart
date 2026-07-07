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
      List<dynamic> rawList = [];

      if (response == null) {
        rawList = [];
      } else if (response is List) {
        rawList = response;
      } else if (response is Map<String, dynamic>) {
        final candidates = <dynamic>[
          response['data'],
          response['results'],
          response['items'],
          response['content'],
          response['payload'],
        ];

        for (final candidate in candidates) {
          if (candidate is List) {
            rawList = candidate;
            break;
          }
        }

        // If no candidate matched but it's a map containing a single list, try to find it.
        if (rawList.isEmpty) {
          for (final value in response.values) {
            if (value is List) {
              rawList = value;
              break;
            }
          }
        }
      }

      final list = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => ExamsHistoryModel.fromJson(e))
          .toList();

      return ApiResult.success(list);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
