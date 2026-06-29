import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/ui/utils/exam_date_formatter.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/exam_status_badge.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';

class InstructorExamCard extends StatelessWidget {
  const InstructorExamCard({
    super.key,
    required this.exam,
    required this.isLive,
    required this.isCompleted,
    required this.enrolledCount,
    this.onTap,
  });
  final ExamModel exam;
  final bool isLive, isCompleted;
  final int enrolledCount;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
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
                  ExamStatusBadge(isLive: isLive, isCompleted: isCompleted),
                ],
              ),
              verticalSpace(8.h),

              Text(exam.description, style: AppTextStyles.whit14w400alpha60),

              if (!isLive && !isCompleted) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      'Exam Code:',
                      style: AppTextStyles.whit14w400alpha60.copyWith(
                        color: AppColors.white60,
                      ),
                    ),
                    horizontalSpace(8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainBlue.withAlpha(20),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.mainBlue.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            exam.examCode,
                            style: AppTextStyles.white16w400.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.mainBlue,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          horizontalSpace(6.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: exam.examCode),
                              );
                              toastification.show(
                                context: context,
                                type: ToastificationType.success,
                                style: ToastificationStyle.fillColored,
                                title: const Text('Exam code copied!'),
                                autoCloseDuration: const Duration(seconds: 2),
                                alignment: Alignment.bottomCenter,
                              );
                            },
                            child: Icon(
                              Icons.copy_rounded,
                              color: AppColors.mainBlue,
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14.sp,
                    color: AppColors.white60,
                  ),
                  horizontalSpace(6.w),
                  Text(
                    formatExamDate(exam.startTime),
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
                    '$enrolledCount',
                    style: AppTextStyles.white12w400alpha40.copyWith(
                      color: AppColors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
