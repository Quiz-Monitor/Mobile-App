
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEvaluationCard extends StatelessWidget {
  const CustomEvaluationCard({
    super.key,
    required this.title,
    required this.subTitle,
  });
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      height: 80.h,
      width: 106.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        //  gradient: LinearGradient(colors: [Colors.grey.shade100 , Colors.white12]),
        color: AppColors.white5,
        border: Border.all(color: AppColors.white10, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.white20.copyWith(fontSize: 24.sp)),
          Text(
            subTitle,
            style: AppTextStyles.whit14w400alpha60.copyWith(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
