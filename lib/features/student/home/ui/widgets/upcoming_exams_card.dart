import 'dart:async';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/ui/widgets/time_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UpcomingExamsCard extends StatefulWidget {
  const UpcomingExamsCard({super.key, required this.examModel});
  final StudentExamModel examModel;

  @override
  State<UpcomingExamsCard> createState() => _UpcomingExamsCardState();
}

class _UpcomingExamsCardState extends State<UpcomingExamsCard> {
  Timer? _timer;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _updateDuration();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateDuration();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateDuration() {
    final remaining = widget.examModel.startTime.difference(DateTime.now());
    if (remaining.isNegative) {
      _duration = Duration.zero;
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
    } else {
      _duration = remaining;
    }
  }

  @override
  Widget build(BuildContext context) {
    final examModel = widget.examModel;
    final days = _duration.inDays;
    final hours = _duration.inHours.remainder(24);
    final minutes = _duration.inMinutes.remainder(60);
    final seconds = _duration.inSeconds.remainder(60);

    return Container(
      padding: EdgeInsets.only(
        left: 22.w,
        right: 22.w,
        top: 22.h,
        bottom: 22.h,
      ),
      decoration: BoxDecoration(
        gradient: examModel.isLive
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.greenAlpha10,
                  AppColors.blueBorder.withAlpha(25),
                ],
              )
            : null,
        color: !examModel.isLive ? AppColors.white5 : null,
        border: Border.all(width: 1.74.w, color: AppColors.white10),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(9.w),
                width: 35.w,
                height: 35.w,
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
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  examModel.examTitle,
                  style: AppTextStyles.whit18w400alpha90.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (examModel.isLive) ...[
                SizedBox(width: 8.w),
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
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.blueBorder.withAlpha(10),
                  AppColors.blueBorder.withAlpha(20),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.blueBorder.withAlpha(75),
                width: 1.74.w,
              ),
            ),
            child: Text(
              '# ${examModel.examCode}',
              style: TextStyle(
                color: AppColors.blueBorder,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeBox(value: days, unit: 'DAYS'),
              TimeBox(value: hours, unit: 'HOURS'),
              TimeBox(value: minutes, unit: 'MINS'),
              TimeBox(value: seconds, unit: 'SECS'),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColors.white10, thickness: 1),
          SizedBox(height: 12.h),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/person.svg',
                width: 16.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  examModel.instructorName,
                  style: AppTextStyles.whit14w400alpha60.copyWith(
                    fontSize: 15.sp,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!examModel.isLive)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white5,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.white10, width: 1.74.w),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/calendar.svg',
                        width: 14.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Scheduled',
                        style: AppTextStyles.white12w400alpha40.copyWith(
                          color: AppColors.white40,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
