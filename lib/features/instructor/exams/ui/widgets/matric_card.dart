
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.iconPath,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final String iconPath;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.7.w),
      decoration: BoxDecoration(
         color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         SvgPicture.asset(iconPath),
         SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          verticalSpace(4.h),
          Text(label, style: AppTextStyles.white12w400alpha60),
        ],
      ),
    );
  }
}
