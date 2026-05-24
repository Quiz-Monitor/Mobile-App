import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_consts.dart';
import 'package:examify/core/networking/models/refresh_token_request_body.dart';
import 'package:examify/core/networking/models/refresh_token_response.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart';
import 'package:examify/features/auth/signup/data/models/signup_response.dart';
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_request_body.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Login service
  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody body);

  // Signup service
  @POST(ApiConstants.signup)
  Future<SignupResponse> signup(@Body() SignupRequestBody body);

  // Refresh token service
  @POST(ApiConstants.refreshToken)
  Future<RefreshTokenResponse> refreshToken(
    @Body() RefreshTokenRequestBody body,
  );

  // Student Exam Join service
  @POST(ApiConstants.studentExamJoin)
  Future<JoinExamResponse> joinExam(@Body() JoinExamRequestBody body);

  // Get exams service
  @GET(ApiConstants.getInstructorExams)
  Future<List<ExamModel>> getExams();

  // Instructor exam results service
  @GET('api/exams/{examId}/results')
  Future<List<InstructorExamResultModel>> getExamResults(
    @Path('examId') int examId,
  );

  // Student upcoming exams service
  @GET(ApiConstants.studentUpcomingExams)
  Future<dynamic> getStudentUpcomingExams();

  @GET(ApiConstants.studentExamHistory)
  Future<dynamic> getStudentExamHistory();

  // User profile service
  @GET(ApiConstants.userProfile)
  Future<dynamic> getUserProfile();
}
