import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';

class InstructorDashboardDto {
  final int totalExams;
  final int liveNow;
  final int upcomingExams;
  final int completedExams;
  final List<ExamModel> exams;

  const InstructorDashboardDto({
    required this.totalExams,
    required this.liveNow,
    required this.upcomingExams,
    required this.completedExams,
    required this.exams,
  });
}

class InstructorHomeRepo {
  final ApiService _apiService;

  InstructorHomeRepo(this._apiService);

  Future<ApiResult<InstructorDashboardDto>> getDashboard() async {
    try {
      final exams = await _apiService.getExams();

      final now = DateTime.now();
      final liveNow = exams.where((exam) => exam.isLiveAt(now)).length;
      final upcomingExams = exams
          .where((exam) => exam.isUpcomingAt(now))
          .length;
      final completedExams = exams
          .where((exam) => exam.isCompletedAt(now))
          .length;

      return ApiResult.success(
        InstructorDashboardDto(
          totalExams: exams.length,
          liveNow: liveNow,
          upcomingExams: upcomingExams,
          completedExams: completedExams,
          exams: exams,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
