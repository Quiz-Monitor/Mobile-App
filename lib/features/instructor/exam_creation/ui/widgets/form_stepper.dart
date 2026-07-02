import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormStepper extends StatelessWidget {
  final int currentStep;

  const FormStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(1),
          _buildLine(currentStep >= 2),
          _buildStep(2),
          _buildLine(currentStep >= 3),
          _buildStep(3),
        ],
      ),
    );
  }

  Widget _buildStep(int step) {
    final bool isCompleted = currentStep > step;
    final bool isCurrent = currentStep == step;

    Color bgColor;
    Color borderColor;
    Widget child;

    if (isCompleted) {
      bgColor = Colors.transparent;
      borderColor = AppColors.mainGreen;
      child = Icon(
        Icons.check_rounded,
        color: AppColors.mainGreen,
        size: 18.sp,
      );
    } else if (isCurrent) {
      bgColor = AppColors.mainBlue;
      borderColor = AppColors.mainBlue;
      child = Text(
        step.toString(),
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      bgColor = Colors.transparent;
      borderColor = AppColors.white10;
      child = Text(
        step.toString(),
        style: TextStyle(
          fontSize: 14.sp,
          color: AppColors.white40,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: child),
    );
  }

  Widget _buildLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: isActive ? AppColors.mainGreen : AppColors.white10,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}
