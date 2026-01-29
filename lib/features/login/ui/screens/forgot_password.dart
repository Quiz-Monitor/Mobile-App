import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 150.h),
                  // Icon
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blueBorder.withAlpha(
                        (255 * 0.1).toInt(),
                      ),
                      border: Border.all(
                        color: AppColors.textblue.withAlpha(
                          (255 * 0.3).toInt(),
                        ),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.email_outlined,
                        color: Color(0xff00D3F2),
                        size: 32.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Title
                  Text(
                    'Forgot Password?',
                    style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
                  ),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    "No worries! Enter your email and we'll send you reset instructions.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.whit14w400alpha60.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // Email Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Email',
                      style: AppTextStyles.whit14w400alpha60.copyWith(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Email Field
                  CustomTextfield(
                    controller: _emailController,
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
                  SizedBox(height: 22.h),

                  // Send Button
                  CustomButton(
                    text: 'Send Reset Link',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Implement Reset Logic
                        print('Reset email sent to ${_emailController.text}');
                      }
                    },
                  ),
                  SizedBox(height: 22.h),

                  // Back to Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to Login',
                      style: AppTextStyles.white16w400.copyWith(
                        color: AppColors.textblue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
