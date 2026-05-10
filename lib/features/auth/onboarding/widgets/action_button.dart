import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:examify/core/themes/colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  final PageController controller;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,

      child: Container(
        height: 56.h,
        width: 327.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xff2b7FFF), Color(0xff9810FA)],
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16.r),
         
        ),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            'Continue',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
