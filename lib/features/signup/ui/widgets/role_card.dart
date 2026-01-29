

import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueBorder.withAlpha((255 * .2).toInt()) // Low opacity blue
              : Colors.white.withAlpha((255 * .05).toInt()), // Slightly lighter than bg
          border: Border.all(
            color: isSelected
                ? AppColors.blueBorder
                : Colors.white.withAlpha((255 * .1).toInt()),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                //gradient: isSelected ? null : LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white30, Colors.white.withAlpha((255 * 0).toInt()), ]) ,
                color: isSelected
                    ? AppColors.blueBorder
                    : Colors.white.withAlpha((255 * .1).toInt()),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: SvgPicture.asset(icon , height: 28.h,),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.white16w400
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenAlpha10.withAlpha((255 * .2).toInt()),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.greenAlpha10.withAlpha((255 * .3).toInt()),
                      ),
                    ),
                    child: Text(
                      'No approval needed',
                      style: TextStyle(
                        color: AppColors.mainGreen,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
