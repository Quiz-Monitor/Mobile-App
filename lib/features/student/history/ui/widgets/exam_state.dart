
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PendingState extends StatelessWidget {
  const PendingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 88.w,
      decoration: BoxDecoration(
        color: AppColors.brown20alpha,
        border: Border.all(color: AppColors.brown30alpha),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: Text('Pending', style: AppTextStyles.brown16w600)),
    );
  }
}
