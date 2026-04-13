import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/auth/signup/data/repo/signup_repo.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_state.dart';
import 'package:examify/features/role/domain/user_role.dart';
import 'package:flutter/widgets.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;
  SignupCubit(this.signupRepo) : super(SignupState.initial());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  void emitSignupState({required UserRole role}) async {
    emit(SignupState.loading());
    final response = await signupRepo.signup(
      fullName: nameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: role,
      phoneNumber: phoneController.text,
    );
    response.when(
      success: (signupResponse) async {
        emit(SignupState.success(signupResponse));
      },
      failure: (error) {
        emit(
          SignupState.failure(error: error),
        );
      },
    );
  }
}
