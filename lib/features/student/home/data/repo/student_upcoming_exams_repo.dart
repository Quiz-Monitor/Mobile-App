import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/data/model/student_upcoming_exams_response.dart';

class StudentUpcomingExamsRepo {
  final ApiService _apiService;

  StudentUpcomingExamsRepo(this._apiService);

  Future<ApiResult<List<StudentExamModel>>> getUpcomingExams() async {
    try {
      final response = await _apiService.getStudentUpcomingExams();
      final parsed = StudentUpcomingExamsResponse.fromResponse(response);
      return ApiResult.success(parsed.exams);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
