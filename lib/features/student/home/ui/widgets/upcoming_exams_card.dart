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

class _UpcomingExamsCardState extends State<UpcomingExamsCard>
    with TickerProviderStateMixin {
  Timer? _timer;
  late Duration _duration;

  // Fade/glow pulse for the badge itself
  late AnimationController _pulseController;

  // Animated glow/shadow intensity
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // --- Pulse (opacity) ---
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // --- Glow intensity ---
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updateDuration();
    if (widget.examModel.isLive) {
      _startLiveAnimations();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateDuration();
          if (widget.examModel.isLive && !_pulseController.isAnimating) {
            _startLiveAnimations();
          } else if (!widget.examModel.isLive && _pulseController.isAnimating) {
            _stopLiveAnimations();
          }
        });
      }
    });
  }

  void _startLiveAnimations() {
    _pulseController.repeat(reverse: true);
  }

  void _stopLiveAnimations() {
    _pulseController.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _updateDuration() {
    final now = DateTime.now();
    Duration remaining;
    if (widget.examModel.isLive) {
      remaining = widget.examModel.endTime.difference(now);
    } else {
      remaining = widget.examModel.startTime.difference(now);
    }
    if (remaining.isNegative) {
      _duration = Duration.zero;
      _timer?.cancel();
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
                _LiveNowBadge(glowAnimation: _glowAnimation),
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
              SvgPicture.asset('assets/icons/person.svg', width: 16.w),
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

/// "Live Now" badge — static container, animated glow shadow + animated dot.
class _LiveNowBadge extends StatelessWidget {
  const _LiveNowBadge({required this.glowAnimation});

  final Animation<double> glowAnimation;

  static const _green = Color(0xff05DF72);
  static const _greenDark = Color(0xff00C950);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowAnimation,
      builder: (_, child) {
        // Interpolate glow: blur 8→26, spread 0→4, alpha 40→120
        final blur = 8.0 + glowAnimation.value * 18.0;
        final spread = glowAnimation.value * 4.0;
        final shadowAlpha = (40 + (glowAnimation.value * 80)).toInt();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_greenDark.withAlpha(55), _green.withAlpha(55)],
            ),
            border: Border.all(color: _green.withAlpha(160), width: 1.74),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: _green.withAlpha(shadowAlpha),
                blurRadius: blur,
                spreadRadius: spread,
              ),
            ],
          ),
          child: child,
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated green dot: scales with glowAnimation
          AnimatedBuilder(
            animation: glowAnimation,
            builder: (_, __) => Transform.scale(
              scale: 0.85 + glowAnimation.value * 0.30,
              child: SvgPicture.asset('assets/icons/greendot.svg'),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            'Live Now',
            style: TextStyle(
              color: _green,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
