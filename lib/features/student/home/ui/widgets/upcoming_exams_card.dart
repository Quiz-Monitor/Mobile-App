import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/home/data/model/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UpcomingExamsCard extends StatelessWidget {
  const UpcomingExamsCard({super.key, required this.examModel});
  final ExamModel examModel;

  Duration _remainingDuration() {
    if (examModel.isLive) {
      return Duration.zero;
    }

    final diff = examModel.dateTime.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  String _examCode() {
    final words = examModel.title
        .split(' ')
        .where((w) => w.trim().isNotEmpty)
        .toList();
    final prefix = words.isEmpty
        ? 'EX'
        : words.take(2).map((w) => w.substring(0, 1).toUpperCase()).join();
    return '$prefix${examModel.dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final duration = _remainingDuration();
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return AspectRatio(
      aspectRatio: 341 / 262,
      child: Container(
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          gradient: examModel.isLive
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.greenAlpha10,
                    AppColors.blueBorder.withAlpha(25),
                    AppColors.blueBorder.withAlpha(25),
                  ],
                )
              : null,
          color: !examModel.isLive ? AppColors.white5 : null,
          border: Border.all(width: 1.74.w, color: AppColors.white10),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(9.w),
                  width: 35.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.blueBorder.withAlpha(50),
                        AppColors.blueBorder.withAlpha(75),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppColors.blueBorder.withAlpha(100),
                      width: 1.74,
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/pc.svg'),
                ),

                SizedBox(width: 8.w),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //     Text(examModel.title, style: AppTextStyles.white16w400),
                //       SizedBox(height: 10.h),
                //       Container(
                //         padding: EdgeInsets.symmetric(
                //           horizontal: 12.w,
                //           vertical: 6.h,
                //         ),
                //         decoration: BoxDecoration(
                //           color: AppColors.blueAlpha10,
                //           borderRadius: BorderRadius.circular(12.r),
                //           border: Border.all(color: AppColors.blueBorder),
                //         ),
                //         child: Text(
                //           '# ${_examCode()}',
                //           style: AppTextStyles.blue14w400,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                if (examModel.isLive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.greenAlpha20,
                      border: Border.all(color: AppColors.mainGreen),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainGreen.withAlpha(70),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 9.w,
                          height: 9.w,
                          decoration: BoxDecoration(
                            color: AppColors.mainGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Live Now',
                          style: AppTextStyles.blue14w400.copyWith(
                            color: AppColors.mainGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 18.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TimeBox(value: days, unit: 'DAYS'),
                _TimeBox(value: hours, unit: 'HOURS'),
                _TimeBox(value: minutes, unit: 'MINS'),
                _TimeBox(value: seconds, unit: 'SECS'),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: AppColors.white10, thickness: 1),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  color: AppColors.greyIcon,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    examModel.prof,
                    style: AppTextStyles.grey16w400,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!examModel.isLive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white5,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.white10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 16.sp,
                          color: AppColors.mainBlue,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'Scheduled',
                          style: AppTextStyles.whit14w400alpha60,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.value, required this.unit});

  final int value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 96.h,
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString().padLeft(2, '0'),
            style: AppTextStyles.white16w400.copyWith(
              fontSize: 40.sp,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            unit,
            style: AppTextStyles.whit14w400alpha60.copyWith(
              fontSize: 16.sp,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
