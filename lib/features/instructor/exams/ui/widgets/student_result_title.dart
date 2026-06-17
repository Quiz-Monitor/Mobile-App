import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentResultTile extends StatelessWidget {
  const StudentResultTile({super.key, 
    required this.row,
    required this.backColors,
    required this.statusColor,
    required this.initials,
  });

  final InstructorExamResultModel row;
  final Color statusColor;
  final List<Color> backColors;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final primaryColor = backColors.isNotEmpty
        ? backColors.last
        : AppColors.white60;
    final borderColor = primaryColor.withAlpha(120);
    final gradientColors = backColors.length >= 2
        ? backColors
        : [primaryColor.withAlpha(40), primaryColor.withAlpha(12)];

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                //  color: scoreColor.withAlpha(75),
                color: borderColor,
                width: 1.74.w,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          horizontalSpace(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(row.studentName, style: AppTextStyles.white16w400),
                verticalSpace(4.h),
               
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${row.finalScore.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (row.totalViolations > 0)
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: statusColor,
                      size: 14.sp,
                    ),
                    horizontalSpace(2.w),
                    Text(
                      '${row.totalViolations}',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              else
                SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
