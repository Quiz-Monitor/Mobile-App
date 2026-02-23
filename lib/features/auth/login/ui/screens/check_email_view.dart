import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter_svg/svg.dart';

class CheckEmailView extends StatelessWidget {
  CheckEmailView({super.key, this.email});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final String? email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  SvgPicture.asset('assets/icons/check.svg'),
                  SizedBox(height: 25.h),

                  // Title
                  Text('Check Your Email', style: AppTextStyles.white16w400),
                  SizedBox(height: 12.h),

                  // Subtitle
                  Text(
                    r"We've sent password reset instructions to",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                  SizedBox(height: 10.h),
                  Text(email.toString(), style: AppTextStyles.blue14w400),
                  SizedBox(height: 30.h),
                  Text(
                    textAlign: TextAlign.center,
                    r"If you don't see the email, check your spam folder or try another email address. ",
                    style: AppTextStyles.whit14w400alpha60,
                  ),

                  // Email Label
                  SizedBox(height: 22.h),

                  // Send Button

                  // Back to Login
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        Routes.loginScreen,
                      );
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
