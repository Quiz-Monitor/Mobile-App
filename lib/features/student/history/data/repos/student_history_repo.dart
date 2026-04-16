import 'package:examify/core/config/app_environment.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/student/history/data/models/history_exam_dto.dart';

// class StudentHistoryRepo {
//   Future<ApiResult<List<HistoryExamDto>>> getHistory() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(<HistoryExamDto>[
//         HistoryExamDto(
//           id: 1,
//           title: 'Machine Learning',
//           date: 'Nov 20, 2024',
//           isPending: false,
//           grade: 18,
//         ),
//         HistoryExamDto(
//           id: 2,
//           title: 'Advanced Physics',
//           date: 'Nov 25, 2024',
//           isPending: true,
//         ),
//       ]);
//     }

//     return const ApiResult.failure(
      
//     );
//   }
// }
