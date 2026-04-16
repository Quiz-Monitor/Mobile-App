import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart'
    as signup_models;
import 'package:examify/features/auth/signup/data/models/signup_response.dart'
    as signup_models;
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
}

void main() {
  group('LoginRepo', () {
    test('returns success result in pre-backend mode', () async {
      final repo = LoginRepo(_FakeApiService());

      final result = await repo.login(
        LoginRequestBody(email: 'ali2@gmail.com', password: 'aaaaaaaa')
      );

      switch (result) {
        case Success(:final data):
          expect(data.user?.email, 'student@examify.test');
        case Failure(:final errorHandler):
          fail('Expected success, got failure: $errorHandler');
      }
    });
  });
}
