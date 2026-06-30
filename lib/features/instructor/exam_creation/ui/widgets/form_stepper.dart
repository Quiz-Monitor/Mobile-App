import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormStepper extends StatelessWidget {
  final int currentStep;

  const FormStepper({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStep(1, currentStep >= 1),
          _buildLine(currentStep >= 2),
          _buildStep(2, currentStep >= 2),
          _buildLine(currentStep >= 3),
          _buildStep(3, currentStep >= 3),
        ],
      ),
    );
  }

  Widget _buildStep(int step, bool isActive) {
    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        color: isActive ? AppColors.mainBlue : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? AppColors.mainBlue : AppColors.white10,
        ),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            fontSize: 14.sp,
            color: isActive ? Colors.white : AppColors.white40,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildLine(bool isActive) {
    return Container(
      width: 60.w,
      height: 1,
      color: isActive ? AppColors.mainBlue : AppColors.white10,
    );
  }
}
