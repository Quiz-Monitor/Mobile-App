import 'dart:ui';

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
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          child: Text(
            textAlign: TextAlign.center,
            subTitle ?? '',
            style: TextStyle(
              fontSize: 18.sp,
              color: Color(0XFFffffff).withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
