import 'package:examify/core/config/app_environment.dart';
import 'package:examify/core/networking/api_result.dart';

class InstructorDashboardDto {
  final int totalExams;
  final int totalStudents;
  final int liveNow;
  final String averageScore;

  const InstructorDashboardDto({
    required this.totalExams,
    required this.totalStudents,
    required this.liveNow,
    required this.averageScore,
  });
}

// class InstructorHomeRepo {
//   Future<ApiResult<InstructorDashboardDto>> getDashboard() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(
//         InstructorDashboardDto(
//           totalExams: 24,
//           totalStudents: 156,
//           liveNow: 2,
//           averageScore: '78%',
//         ),
//       );
//     }

//     return const ApiResult.failure(
//       'Instructor dashboard endpoint is not ready yet.',
//     );
//   }
// }
