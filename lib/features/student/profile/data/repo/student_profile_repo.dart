
class StudentProfileDto {
  final int userId;
  final String fullName;
  final String email;

  const StudentProfileDto({
    required this.userId,
    required this.fullName,
    required this.email,
  });
}

// class StudentProfileRepo {
//   Future<ApiResult<StudentProfileDto>> getProfile() async {
//     if (AppEnvironmentConfig.useMockApi) {
//       return const ApiResult.success(
//         StudentProfileDto(
//           userId: 1,
//           fullName: 'Mock Student',
//           email: 'student@examify.test',
//         ),
//       );
//     }

//     return const ApiResult.failure(
//       'Student profile endpoint is not ready yet.',
//     );
//   }
// }
