import 'dart:ui';

import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Package extends StatelessWidget {
  final String? imagePath, heading, subTitle;
  const Package({super.key, this.imagePath, this.subTitle, this.heading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 256.h,
          width: 256.w,
          child: SvgPicture.asset(imagePath!),
        ),
        SizedBox(height: 48.h),
        Text(
          heading ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            textAlign: TextAlign.center,
            subTitle ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.white40,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
