import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(11.w),
          decoration: BoxDecoration(
            color: AppColors.mainBlue.withAlpha(35),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(icon, color: AppColors.mainBlue, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppTextStyles.white16w400.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
