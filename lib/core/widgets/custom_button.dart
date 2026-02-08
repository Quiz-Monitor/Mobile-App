import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, this.onPressed, required this.buttonContent});
  final void Function()? onPressed;
  final Widget buttonContent;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: Size(double.infinity, 50.h),
        backgroundColor: AppColors.blueBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      onPressed: onPressed,
      child: FittedBox(fit: BoxFit.scaleDown, child: buttonContent),
    );
  }
}
