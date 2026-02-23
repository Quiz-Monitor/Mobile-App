
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: AppTextStyles.grey16w400,
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, Routes.roleSelectionScreen);
          },
          child: Text(
            'Sign up',
            style: AppTextStyles.blue14w400.copyWith(fontSize: 16.sp),
          ),
        ),
      ],
    );
  }
}
