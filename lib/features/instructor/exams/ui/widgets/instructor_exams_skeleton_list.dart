import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InstructorExamsSkeletonList extends StatelessWidget {
  const InstructorExamsSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructor Exams', style: AppTextStyles.white20),
        SizedBox(height: 16.h),
        Expanded(
          child: Skeletonizer(
            enabled: true,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withAlpha(18)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Advanced Physics Midterm Exam',
                              style: AppTextStyles.white20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff00D3F3).withAlpha(40),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Scheduled',
                              style: TextStyle(
                                color: const Color(0xff00D3F3),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Exam description placeholder for loading skeleton state.',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Code: PHYS2026',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Starts: Apr 23, 11:30 AM',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
