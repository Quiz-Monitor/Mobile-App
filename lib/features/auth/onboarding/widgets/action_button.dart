import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff2B7FFF), Color(0xff9810FA)],
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            textAlign: TextAlign.center,
            'Continue',
            style: TextStyle(color: Color(0xffffffff), fontSize: 16.sp),
          ),
        ),
      ),
    );
  }
}
