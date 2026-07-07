import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/data/model/student_upcoming_exams_response.dart';
import 'package:flutter/foundation.dart';

class StudentUpcomingExamsRepo {
  final ApiService _apiService;

  StudentUpcomingExamsRepo(this._apiService);

  Future<ApiResult<List<StudentExamModel>>> getUpcomingExams() async {
    try {
      final response = await _apiService.getStudentUpcomingExams();
      debugPrint(
        '[StudentUpcomingExamsRepo] Raw response type: ${response.runtimeType}',
      );
      debugPrint('[StudentUpcomingExamsRepo] Raw response: $response');
      final parsed = StudentUpcomingExamsResponse.fromResponse(response);
      debugPrint(
        '[StudentUpcomingExamsRepo] Parsed exams count: ${parsed.exams.length}',
      );
      return ApiResult.success(parsed.exams);
    } on DioException catch (e) {
      debugPrint('[StudentUpcomingExamsRepo] DioException: ${e.message}');
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e, stackTrace) {
      debugPrint('[StudentUpcomingExamsRepo] Exception: $e');
      debugPrint('[StudentUpcomingExamsRepo] StackTrace: $stackTrace');
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
