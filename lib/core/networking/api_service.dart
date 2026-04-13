import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_consts.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/model/login_response.dart';
import 'package:examify/features/auth/signup/data/models/signup_request_body.dart';
import 'package:examify/features/auth/signup/data/models/signup_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(@Body() LoginRequestBody body);

  @POST(ApiConstants.signup)
  Future<SignupResponse> signup(@Body() SignupRequestBody body);
}
