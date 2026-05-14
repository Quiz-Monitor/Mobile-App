
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InstructorExamCard extends StatelessWidget {
  const InstructorExamCard({
    super.key,
    required this.exam,
    required this.isLive,
    required this.isCompleted,
  });
  final ExamModel exam;
  final bool isLive, isCompleted;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xffAD46FF).withAlpha(8)
            : isLive
            ? const Color(0xff00C950).withAlpha(8)
            : const Color(0xff2B7FFF).withAlpha(8),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(exam.title, style: AppTextStyles.white16w400),
              ),
              horizontalSpace(8.w),
              ExamCardState(isLive: isLive, isCompleted: isCompleted),
            ],
          ),
          verticalSpace(8.h),

          Text(exam.description, style: AppTextStyles.whit14w400alpha60),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14.sp,
                color: AppColors.white60,
              ),
              horizontalSpace(6.w),
              Text(
                formatDate(exam.startTime),
                style: AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.white60,
                ),
              ),
              horizontalSpace(16.w),
              Icon(
                Icons.access_time_outlined,
                color: AppColors.white60,
                size: 14.sp,
              ),
              horizontalSpace(6.w),
              Text(
                '${exam.durationMinutes}m',
                style: AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.white60,
                ),
              ),
              horizontalSpace(16.w),
              SvgPicture.asset(
                'assets/icons/students.svg',
                colorFilter: ColorFilter.mode(
                  AppColors.white60,
                  BlendMode.srcIn,
                ),
                width: 14.w,
              ),
              horizontalSpace(6.w),
              Text(
                '45',
                style: AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.white60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
