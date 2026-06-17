
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeBox extends StatelessWidget {
  const TimeBox({super.key, required this.value, required this.unit});

  final int value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62.w,
      height: 74.h,

      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.white16w400.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            unit,
            style: AppTextStyles.whit14w400alpha60.copyWith(
              color: AppColors.white40,
              fontSize: 10.sp,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}