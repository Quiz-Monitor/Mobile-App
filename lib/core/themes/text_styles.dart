
import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle white16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white
  );
  static TextStyle white14w400alpha70 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white.withAlpha((255 * .7).toInt())
  );
  static TextStyle white12w400alpha40 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white.withAlpha((255 * .4).toInt())
  );
  static TextStyle brown16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.brownText
  );
  static TextStyle white20 = TextStyle(
    fontSize: 20.sp,
    color: Colors.white
  );
  static TextStyle grey16w400 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greyText
  );
  static TextStyle blue14w400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textblue
  );
  static TextStyle whit14w400alpha60 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: Colors.white.withAlpha((255 * .6).round())
  );
  
  
}