import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
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
  final InstructorExamsRepo _instructorExamsRepo;

  InstructorHomeRepo(this._instructorExamsRepo);

  Future<ApiResult<InstructorDashboardDto>> getDashboard() async {
    final result = await _instructorExamsRepo.getInstructorExams();

    return result.when(
      success: (exams) {
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
      },
      failure: (error) => ApiResult.failure(error),
    );
  }
}
