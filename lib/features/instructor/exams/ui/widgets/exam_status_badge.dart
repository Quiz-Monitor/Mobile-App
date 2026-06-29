import 'package:examify/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamStatusBadge extends StatelessWidget {
  const ExamStatusBadge({
    super.key,
    required this.isLive,
    required this.isCompleted,
  });

  final bool isLive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xffAD46FF).withAlpha(50)
            : isLive
            ? const Color(0xff00C950).withAlpha(50)
            : const Color(0xff2B7FFF).withAlpha(50),
        border: Border.all(
          color: isCompleted
              ? const Color(0xffA855F7).withAlpha(75)
              : isLive
              ? const Color(0xff00C950).withAlpha(75)
              : const Color(0xff2B7FFF).withAlpha(75),
          width: 1.74.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: isCompleted
          ? Text(
              'Completed',
              style: TextStyle(
                color: const Color(0xffC084FC),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          : isLive
          ? Row(
              children: [
                Icon(Icons.circle, size: 6, color: const Color(0xff05DF72)),
                horizontalSpace(4.w),
                Text(
                  'Live',
                  style: TextStyle(
                    color: const Color(0xff05DF72),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : Text(
              'Upcoming',
              style: TextStyle(
                color: const Color(0xff51A2FF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}
