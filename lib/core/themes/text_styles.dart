
import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static TextStyle white16w400 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white
  );
  static TextStyle blue14w400 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textblue
  );
  static TextStyle whit14w400alpha60 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white.withAlpha((255 * .6).round())
  );
  
  
}