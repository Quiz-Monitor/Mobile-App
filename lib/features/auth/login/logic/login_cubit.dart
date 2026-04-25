import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/features/auth/login/data/model/login_request_body.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/login/logic/login_state.dart';
import 'package:flutter/widgets.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;
  final SessionStorage sessionStorage;

  LoginCubit(this.loginRepo, this.sessionStorage) : super(LoginState.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  void emitLoginState() async {
    emit(LoginState.loading());
    final response = await loginRepo.login(
      LoginRequestBody(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      ),
    );
    response.when(
      success: (loginResponse) async {
        await sessionStorage.saveSession(
          accessToken: loginResponse.token,
          refreshToken: loginResponse.refreshToken,
          role: loginResponse.user?.role,
          userId: loginResponse.user?.userId,
          fullName: loginResponse.user?.fullName,
          email: loginResponse.user?.email,       
        );
        emit(LoginState.success(loginResponse));
      },
      failure: (error) {
        emit(
          LoginState.failure(error: error.apiErrorModel.getAllErrorMessages()),
        );
      },
    );
  }
}
