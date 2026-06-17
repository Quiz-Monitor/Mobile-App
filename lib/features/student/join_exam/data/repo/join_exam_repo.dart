import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_request_body.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_response.dart';

class JoinExamRepo {
  final ApiService _apiService;

  JoinExamRepo(this._apiService);

  Future<ApiResult<JoinExamResponse>> joinExam(String examCode) async {
    try {
      final response = await _apiService.joinExam(
        JoinExamRequestBody(examCode: examCode.trim()),
      );
      return ApiResult.success(response);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == ResponseCode.UNAUTHORISED) {
        return ApiResult.failure(
          ErrorHandler.handle(Exception('Unauthorized. Please login again.')),
        );
      }

      if (statusCode == ResponseCode.FORBIDDEN) {
        return ApiResult.failure(
          ErrorHandler.handle(
            Exception('You are not allowed to join this exam.'),
          ),
        );
      }

      if (statusCode == ResponseCode.NOT_FOUND) {
        return ApiResult.failure(
          ErrorHandler.handle(Exception('Exam not found for this code.')),
        );
      }

      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
