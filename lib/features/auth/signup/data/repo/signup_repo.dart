import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart';
import 'package:examify/features/auth/signup/data/models/signup_response.dart';
import 'package:examify/features/role/domain/user_role.dart';

class SignupRepo {
  final ApiService apiService;

  SignupRepo(this.apiService);

  Future<ApiResult<SignupResponse>> signup({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
    required String? phoneNumber,
  }) async {
    try {
      final roleString = role == UserRole.student ? 'Student' : 'Teacher';
      final response = await apiService.signup(
        SignupRequestBody(
          fullName: fullName,
          email: email,
          password: password,
          role: roleString,
          phoneNumber: phoneNumber,
        ),
      );

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e) );
    }
  }
}
