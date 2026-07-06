import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';

class InstructorDashboardDto {
  final int totalExamsCreated;
  final int totalUniqueStudents;
  final double averageScorePercentage;
  final int liveNow;
  final int upcomingExams;
  final int completedExams;
  final List<ExamModel> exams;
  final List<ExamModel> liveExams;

  const InstructorDashboardDto({
    required this.totalExamsCreated,
    required this.totalUniqueStudents,
    required this.averageScorePercentage,
    required this.liveNow,
    required this.upcomingExams,
    required this.completedExams,
    required this.exams,
    required this.liveExams,
  });
}

class InstructorHomeRepo {
  final ApiService _apiService;

  InstructorHomeRepo(this._apiService);

  Future<ApiResult<InstructorDashboardDto>> getDashboard() async {
    try {
      final statisticsResponse = await _apiService.getInstructorProfile();
      final exams = await _apiService.getExams();
      // No dedicated live endpoint — filter client-side.
      // isLive = isPublished && startTime <= now && now <= endTime
      final liveExams = exams.where((e) => e.isLive).toList();

      final liveNow = liveExams.length;
      final upcomingExams = exams.where((exam) => exam.isUpcoming).length;
      final completedExams = exams.where((exam) => exam.isCompleted).length;

      return ApiResult.success(
        InstructorDashboardDto(
          totalExamsCreated:
              statisticsResponse.examOverview?.totalExamsCreated ??
              exams.length,
          totalUniqueStudents:
              statisticsResponse.studentOverview?.totalUniqueStudents ?? 0,
          averageScorePercentage:
              statisticsResponse.scoreStatistics?.averageScorePercentage ?? 0.0,
          liveNow: liveNow,
          upcomingExams: upcomingExams,
          completedExams: completedExams,
          exams: exams,
          liveExams: liveExams,
        ),
      );
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
