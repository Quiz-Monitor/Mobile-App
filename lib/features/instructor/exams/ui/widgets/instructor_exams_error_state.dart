import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamsErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;

  const InstructorExamsErrorState({
    super.key,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.mainBlue,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(height: 140.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(
              child: Text(
                message,
                style: AppTextStyles.white20,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
