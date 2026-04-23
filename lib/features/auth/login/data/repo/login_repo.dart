import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';

class LoginRepo {
  final ApiService apiService;

  LoginRepo(this.apiService);

  Future<ApiResult<LoginResponse>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await apiService.login(loginRequestBody);

      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}

//   Future<ApiResult<ForgotPasswordResponse>> forgotPassword({
//     required String email,
//   }) async {
//     if (AppEnvironmentConfig.useMockApi) {
//       await Future<void>.delayed(const Duration(milliseconds: 400));
//       return const ApiResult.success(
//         ForgotPasswordResponse(
//           message: 'If the email exists, reset instructions will be sent.',
//         ),
//       );
//     }

//     try {
//       // Endpoint placeholder until backend contract is finalized.
//       final _ = ForgotPasswordRequestBody(email: email).toJson();
//       return const ApiResult.success(
//         ForgotPasswordResponse(
//           message: 'Endpoint ready. Connect API call in ApiService.',
//         ),
//       );
//     } catch (e) {
//       return ApiResult.failure(
//         ErrorHandler.handle(e).apiErrorModel.getAllErrorMessages(),
//       );
//     }
//   }
// }
