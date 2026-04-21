import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/home/data/model/exam_model.dart';
import 'package:examify/features/student/home/ui/widgets/time_box.dart';
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
    // final duration = _remainingDuration();
    // final days = duration.inDays;
    // final hours = duration.inHours.remainder(24);
    // final minutes = duration.inMinutes.remainder(60);
    // final seconds = duration.inSeconds.remainder(60);

    return AspectRatio(
      aspectRatio: 341/ 262,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          gradient: examModel.isLive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.greenAlpha10,
                    AppColors.blueBorder.withAlpha(25),
                    // AppColors.blueBorder.withAlpha(25),
                  ],
                )
              : null,
          color: !examModel.isLive ? AppColors.white5 : null,
          border: Border.all(width: 1.74.w, color: AppColors.white10),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpace(22) ,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Text(examModel.title, style: AppTextStyles.whit18w400alpha90),

                SizedBox(width: 8.w),
               
                if (examModel.isLive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff00C950).withAlpha(50),
                          Color(0xff05DF72).withAlpha(50),
                        ],
                      ),
                      border: Border.all(
                        color: Color(0xff05DF72).withAlpha(100),
                        width: 1.74,
                      ),
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
                        SvgPicture.asset('assets/icons/greendot.svg'),
                        SizedBox(width: 8.w),
                        Text(
                          'Live Now',
                          style: AppTextStyles.blue14w400.copyWith(
                            color: AppColors.mainGreen,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blueBorder.withAlpha(25),
                    AppColors.blueBorder.withAlpha(50),
                  ],
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.blueBorder.withAlpha(75) , width: 1.74.w),
              ),
              child: Text(
                '# ${_examCode()}',
                style: TextStyle(
                  color: AppColors.blueBorder,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TimeBox(value: examModel.dateTime.day, unit: 'DAYS'),
                TimeBox(value: examModel.dateTime.hour, unit: 'HOURS'),
                TimeBox(value: examModel.dateTime.minute, unit: 'MINS'),
                TimeBox(value: examModel.dateTime.second, unit: 'SECS'),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: AppColors.white10, thickness: 1),
            SizedBox(height: 6.h),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/students.svg',
                  color: AppColors.white40,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    examModel.prof,
                    style: AppTextStyles.whit14w400alpha60,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!examModel.isLive)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white5,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.white10,
                        width: 1.74.w,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/calendar.svg'),
                        SizedBox(width: 6.w),
                        Text(
                          'Scheduled',
                          style: AppTextStyles.white12w400alpha40,
                        ),
                      ],
                    ),
                    
                    
                  ),
                  SizedBox(height: 27.h,)
              ],
            ),
          ],
        ),
      ),
    );
  }
}

