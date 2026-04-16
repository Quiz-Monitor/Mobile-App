import 'package:examify/core/config/app_environment.dart';
import 'package:examify/core/networking/api_result.dart';

class InstructorReportDto {
  final int examId;
  final String examTitle;
  final double averageScore;

  const InstructorReportDto({
    required this.examId,
    required this.examTitle,
    required this.averageScore,
  });
}

// class InstructorReportsRepo {
//   Future<ApiResult<List<InstructorReportDto>>> getReports() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(<InstructorReportDto>[
//         InstructorReportDto(
//           examId: 1,
//           examTitle: 'CS-101 Midterm',
//           averageScore: 78.5,
//         ),
//       ]);
//     }

//     return const ApiResult.failure(
//       'Instructor reports endpoint is not ready yet.',
//     );
//   }
// }
