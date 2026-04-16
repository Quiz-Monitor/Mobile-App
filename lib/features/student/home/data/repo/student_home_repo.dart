import 'package:examify/core/config/app_environment.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/home/data/model/upcoming_exam_dto.dart';

// class StudentHomeRepo {
//   Future<ApiResult<List<UpcomingExamDto>>> getUpcomingExams() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(<UpcomingExamDto>[
//         UpcomingExamDto(
//           id: 1,
//           title: 'Physics Midterm',
//           time: '10:42 PM',
//           participants: 45,
//           daysLeft: '2d',
//         ),
//         UpcomingExamDto(
//           id: 2,
//           title: 'Chemistry Quiz',
//           time: '10:42 PM',
//           participants: 38,
//           daysLeft: '5d',
//         ),
//       ]);
//     }

//     return const ApiResult.failure('Student home endpoint is not ready yet.');
//   }
// }
