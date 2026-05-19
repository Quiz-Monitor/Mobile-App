import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/models/refresh_token_request_body.dart';
import 'package:examify/core/networking/models/refresh_token_response.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/auth/login/logic/login_state.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart'
    as signup_models;
import 'package:examify/features/auth/signup/data/models/signup_response.dart'
    as signup_models;
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/home/data/models/get_exams_response.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_request_body.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_response.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeApiService implements ApiService {
  @override
  Future<LoginResponse> login(LoginRequestBody body) async {
    return LoginResponse(
      token: 'fake_token',
      refreshToken: 'fake_refresh',
      message: 'ok',
      user: User(
        userId: 1,
        email: body.email,
        fullName: 'Fake',
        role: 'Student',
      ),
    );
  }

  @override
  Future<signup_models.SignupResponse> signup(
    signup_models.SignupRequestBody body,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequestBody body) {
    throw UnimplementedError();
  }

  @override
  Future<JoinExamResponse> joinExam(JoinExamRequestBody body) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<GetExamsResponse> getStudentUpcomingExams() {
    // TODO: implement getStudentUpcomingExams
    throw UnimplementedError();
  }

  @override
  Future<List<ExamModel>> getExams() {
    throw UnimplementedError();
  }

  @override
  Future<List<InstructorExamResultModel>> getExamResults(int examId) {
    // TODO: implement getExamResults
    throw UnimplementedError();
  }
}

void main() {
  test('LoginCubit emits loading then success', () async {
    final cubit = LoginCubit(
      LoginRepo(_FakeApiService()),
      InMemorySessionStorage(),
    );

    cubit.emailController.text = 'student@examify.test';
    cubit.passwordController.text = '123456';

    final states = <LoginState>[];
    final sub = cubit.stream.listen(states.add);

    cubit.emitLoginState();
    await Future<void>.delayed(const Duration(milliseconds: 900));

    expect(states.first, isA<Loading>());
    expect(states.last, isA<LoginSuccess>());

    await sub.cancel();
    await cubit.close();
  });
}
