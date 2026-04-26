import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_state.dart';
import 'package:examify/features/auth/signup/ui/widgets/alreadyhaveaccount.dart';
import 'package:examify/features/role/logic/cubit/role_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignupCubit, SignupState>(
        listenWhen: (previous, current) =>
            current is SignupSuccess || current is SignupFailure,
        listener: (context, state) {
          state.whenOrNull(
            success: (signupResponse) {
              Navigator.pushReplacementNamed(context, Routes.loginScreen);
              toastification.show(
                autoCloseDuration: const Duration(seconds: 5),
                style: ToastificationStyle.fillColored,
                description: RichText(
                  text: const TextSpan(text: 'Signup Successful! Please Login'),
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
              key: context.read<SignupCubit>().formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 52.h),
                  Image.asset('assets/images/app_logo.png', height: 80.h),
                  SizedBox(height: 25.h, width: double.infinity),
                  Text(
                    'Create Account',
                    style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sign up to get started',
                    style: AppTextStyles.whit14w400alpha60.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Full Name',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context.read<SignupCubit>().nameController,
                    hintText: 'Ali Ahmad Taha Saed',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Email',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context.read<SignupCubit>().emailController,
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
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Phone number (optional)',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context.read<SignupCubit>().phoneController,
                    hintText: '+20',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.toString().length < 11) {
                        return 'Please enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Password',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context.read<SignupCubit>().passwordController,
                    hintText: 'Enter your password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Confirm Password',
                      style: AppTextStyles.whit14w400alpha60,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    controller: context
                        .read<SignupCubit>()
                        .confirmPasswordController,
                    hintText: 'Confirm your password',
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value !=
                          context.read<SignupCubit>().passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  // BlocBuilder<SignupCubit, SignupState>(
                  //   builder: (context, state) {
                  //     return CustomButton(
                  //       buttonContent: state is Loading
                  //           ? const CircularProgressIndicator(
                  //               color: Colors.white,
                  //             )
                  //           : Text('Sign Up', style: AppTextStyles.white16w400),
                  //       onPressed: () {
                  //         if (context.read<SignupCubit>().formkey.currentState!.validate()) {
                  //           final selectedRole = context.read<RoleCubit>().state;
                  //           context.read<SignupCubit>().emitSignupState(
                  //             role: selectedRole,
                  //           );
                  //         }
                  //       },
                  //     );
                  //   },
                  // ),
                  CustomButton(
                    onPressed: () {
                      if (context
                          .read<SignupCubit>()
                          .formkey
                          .currentState!
                          .validate()) {
                        final selectedRole = context.read<RoleCubit>().state;
                        context.read<SignupCubit>().emitSignupState(
                          role: selectedRole,
                        );
                      }
                    },
                    buttonContent: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return state.when(
                          initial: () =>
                              Text('Sign up', style: AppTextStyles.white16w400),
                          loading: () =>
                              CircularProgressIndicator(color: Colors.white),
                          success: (SignupResponse) =>
                              Text('Sign up', style: AppTextStyles.white16w400),
                          failure: (error) =>
                              Text('Sign up', style: AppTextStyles.white16w400),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.h),
                  const AlreadyHaveAccount(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
