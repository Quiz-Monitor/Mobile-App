import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.controller , required this.onPressed});

  final PageController controller;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff206DFD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        fixedSize: Size(327.w, 56.h),
      ),
      onPressed: onPressed,
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Continue',
          style: TextStyle(color: Color(0xffffffff), fontSize: 16.sp),
        ),
      ),
    );
  }
}
