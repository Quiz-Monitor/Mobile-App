import 'package:examify/core/config/app_environment.dart';
import 'package:examify/core/networking/api_result.dart';

class InstructorExamDto {
  final int id;
  final String title;
  final String status;

  const InstructorExamDto({
    required this.id,
    required this.title,
    required this.status,
  });
}

// class InstructorExamsRepo {
//   Future<ApiResult<List<InstructorExamDto>>> getInstructorExams() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(<InstructorExamDto>[
//         InstructorExamDto(id: 1, title: 'CS-101 Midterm', status: 'Live'),
//         InstructorExamDto(id: 2, title: 'Math Advanced', status: 'Upcoming'),
//       ]);
//     }

//     return const ApiResult.failure(
//       'Instructor exams endpoint is not ready yet.',
//     );
//   }
// }
