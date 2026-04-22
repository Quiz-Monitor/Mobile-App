import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/auth/login/logic/login_state.dart';
import 'package:examify/features/auth/login/ui/widgets/donthaveaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            current is LoginSuccess || current is LoginFailure,
        listener: (context, state) {
          state.whenOrNull(
            success: (loginResponse) {
              final role = loginResponse.user?.role?.trim().toLowerCase();
              if (role == 'student') {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.homeScreen,
                );
              } else if (role == 'instructor' || role == 'teacher') {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.instructorHomeScreen,
                );
              } else {
                Navigator.pushReplacementNamed(context, Routes.homeScreen);
              }
              toastification.show(
                autoCloseDuration: const Duration(seconds: 5),
                style: ToastificationStyle.fillColored,
                description: RichText(
                  text: TextSpan(text: 'Login Successful!'),
                ),
                context: context,
                type: ToastificationType.success,
              );
            },
            failure: (errorMessage) {
              toastification.show(
                autoCloseDuration: const Duration(seconds: 5),
                style: ToastificationStyle.fillColored,
                description: RichText(
                  text: TextSpan(text: errorMessage.toString()),
                ),
                context: context,
                type: ToastificationType.error,
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Form(
              key: context.read<LoginCubit>().formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 163.h),
                  Image.asset('assets/images/app_logo.png', height: 80.h),
                  SizedBox(height: 25.h, width: double.infinity),

                  Text(
                    'Welcome Back',
                    style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sign in to continue  ',
                    style: AppTextStyles.whit14w400alpha60.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 27.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Email',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context.read<LoginCubit>().emailController,
                    hintText: 'your.email@example.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Text('Password', style: AppTextStyles.whit14w400alpha60),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.forgotPasswordScreen,
                          );
                        },
                        child: Text(
                          'Forgot Password?  ',
                          style: AppTextStyles.blue14w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  CustomTextfield(
                    controller: context.read<LoginCubit>().passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  CustomButton(
                    onPressed: () {
                      validateThenDoLogin(context);
                    },
                    buttonContent: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () =>
                              Text('Log in', style: AppTextStyles.white16w400),
                          loading: () => CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                          success: (LoginResponse) =>
                              Text('Log in', style: AppTextStyles.white16w400),
                          failure: (error) =>
                              Text('Log in', style: AppTextStyles.white16w400),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),
                  DontHaveAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void validateThenDoLogin(BuildContext context) {
    if (context.read<LoginCubit>().formkey.currentState!.validate()) {
      context.read<LoginCubit>().emitLoginState();
    }
  }
}
