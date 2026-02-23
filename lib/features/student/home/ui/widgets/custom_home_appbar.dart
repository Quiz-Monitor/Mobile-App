import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHomeAppbar extends StatelessWidget {
  const CustomHomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              //borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [AppColors.blueBorder, AppColors.mainIndego],
              ),
            ),
            child: Center(child: Text('A', style: AppTextStyles.white16w400)),
          ),
        ),
        SizedBox(width: 8.w),
        Text('Hi ,Ali Ahmad', style: AppTextStyles.white16w400),
      ],
    );
  }
}
