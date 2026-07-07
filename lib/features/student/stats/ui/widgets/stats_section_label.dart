import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable section label with an icon, used across all stats sections.
class StatsSectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;

  const StatsSectionLabel({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.blueBorder, size: 18.r),
        SizedBox(width: 8.w),
        Text(
          text,
          style: AppTextStyles.white16w400.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
