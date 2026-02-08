import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/login/ui/screens/check_email_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 150.h),

                // Icon
                SvgPicture.asset('assets/icons/forgrotpassword.svg'),
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
                  buttonContent: Text(
                    'Send Rest Link',
                    style: AppTextStyles.white16w400,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckEmailView(email: _emailController.text.toString()),
                        ),
                      );
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
    );
  }
}
