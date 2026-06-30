import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/models/refresh_token_request_body.dart';
import 'package:examify/core/networking/models/refresh_token_response.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart'
    as signup_models;
import 'package:examify/features/auth/signup/data/models/signup_response.dart'
    as signup_models;
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_request_body.dart';
import 'package:examify/features/student/join_exam/data/model/join_exam_response.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/grading/data/models/written_answer_model.dart';
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
  Future<List<ExamModel>> getExams() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getUserProfile() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getStudentUpcomingExams() {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> getStudentExamHistory() {
    throw UnimplementedError();
  }

  @override
  Future<List<InstructorExamResultModel>> getExamResults(int examId) {
    // TODO: implement getExamResults
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword(dynamic body) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount(dynamic body) {
    throw UnimplementedError();
  }

  @override
  Future<CreateExamResponse> createExam(CreateExamRequestBody body) {
    throw UnimplementedError();
  }

  @override
  Future<AddQuestionResponse> addExamQuestion(
    int examId,
    AddQuestionRequestBody body,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateExamQuestion(
    int examId,
    int questionId,
    AddQuestionRequestBody body,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionLocalDto>> getExamQuestions(int examId) {
    throw UnimplementedError();
  }

  @override
  Future<void> publishExam(int examId) {
    throw UnimplementedError();
  }

  @override
  Future<List<WrittenAnswerModel>> getWrittenAnswers(
    int examId,
    int studentId,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> gradeAnswer(int answerId, GradeRequestBody body) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteExam(int examId) {
    throw UnimplementedError();
  }
}

void main() {
  group('LoginRepo', () {
    test('returns success result in pre-backend mode', () async {
      final repo = LoginRepo(_FakeApiService());

      final result = await repo.login(
        LoginRequestBody(email: 'ali2@gmail.com', password: 'aaaaaaaa'),
      );

      switch (result) {
        case Success(:final data):
          expect(data.user?.email, 'ali2@gmail.com');
        case Failure(:final errorHandler):
          fail('Expected success, got failure: $errorHandler');
      }
    });
  });
}
