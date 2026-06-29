import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamsSearchBar extends StatelessWidget {
  const InstructorExamsSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
          ),
        ),
        child: SearchBar(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.w),
          ),
          controller: controller,
          hintText: 'Search exams...',
          onChanged: onChanged,
          leading: Icon(Icons.search_rounded, color: AppColors.white40),
          backgroundColor: WidgetStatePropertyAll(AppColors.white5),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.white10, width: 1.74.w),
          ),
          textStyle: WidgetStatePropertyAll(AppTextStyles.white16w400),
          hintStyle: WidgetStatePropertyAll(
            AppTextStyles.white16w400.copyWith(color: AppColors.white40),
          ),
        ),
      ),
    );
  }
}
