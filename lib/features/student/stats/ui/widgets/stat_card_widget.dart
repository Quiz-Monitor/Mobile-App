import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatCardWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Gradient gradient;

  const StatCardWidget({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withAlpha(200), size: 20.r),
          SizedBox(height: 8.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withAlpha(180),
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient presets used by StatCardWidget
class StatCardGradients {
  static const submitted = LinearGradient(
    colors: [Color(0xff2B7FFF), Color(0xff206DFD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient graded() => LinearGradient(
    colors: [AppColors.mainGreen.withAlpha(200), const Color(0xff00A850)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient pending() => LinearGradient(
    colors: [AppColors.brownText.withAlpha(200), const Color(0xffE09900)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
