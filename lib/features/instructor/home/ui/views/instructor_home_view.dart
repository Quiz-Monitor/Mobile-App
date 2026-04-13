import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/features/instructor/home/ui/widgets/live_exams.dart';
import 'package:examify/features/instructor/home/ui/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InstructorHomeView extends StatelessWidget {
  const InstructorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(8),
                Text('Dashboard', style: AppTextStyles.white16w400),
                Text(
                  'Welcome back, Dr. Ahmed',
                  style: AppTextStyles.white14w400alpha70,
                ),
                verticalSpace(24),
                // Stats Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 165.5 / 140,
                  children: [
                    StatCard(
                      borderIconColor: const Color(0xff00D3F3),
                      iconUrl: 'assets/icons/exams.svg',
                      value: '24',
                      label: 'Total Exams',
                      iconColor: const Color(0xff00B8DB),
                    ),
                    StatCard(
                      borderIconColor: const Color(0xff51A2FF),
                      iconUrl: 'assets/icons/students.svg',
                      value: '156',
                      label: 'Total Students',
                      iconColor: const Color(0xff2B7FFF),
                    ),
                    StatCard(
                      borderIconColor: const Color(0xff05DF72),
                      iconUrl: 'assets/icons/live.svg',
                      value: '2',
                      label: 'Live Now',
                      iconColor: const Color(0xff00C950),
                    ),
                    StatCard(
                      borderIconColor: const Color(0xffC27AFF),
                      iconUrl: 'assets/icons/trend.svg',
                      value: '78%',
                      label: 'Avg Score',
                      iconColor: const Color(0xffAD46FF),
                    ),
                  ],
                ),

                verticalSpace(24),

                // Live Exams Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Live Exams',
                      style: AppTextStyles.white16w400.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff00C950).withAlpha(50),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          width: 1.74.w,
                          color: const Color(0xff00C950).withAlpha(75),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.w,
                            decoration: const BoxDecoration(
                              color: Color(0xff05DF72),
                              shape: BoxShape.circle,
                            ),
                          ),
                          horizontalSpace(5),
                          Text(
                            '2 Active',
                            style: TextStyle(
                              color: const Color(0xff05DF72),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                verticalSpace(13),
                LiveExamCard(title: 'CS-101 Midterm', studentsCount: 45),
                verticalSpace(12),
                LiveExamCard(title: 'Math Advanced', studentsCount: 32),

                verticalSpace(24),

                // Upcoming Exams Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Exams',
                      style: AppTextStyles.white16w400
                    ),
                    TextButton.icon(
                      onPressed: () {},
                     
                      label: Text(
                        'View All',
                        style: TextStyle(
                          color: const Color(0xff00D3F3),
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(12),
                _UpcomingExamCard(
                  title: 'Physics Midterm',
                  time: '10:42 PM',
                  participants: 45,
                  daysLeft: '2d',
                ),
                verticalSpace(12),
                _UpcomingExamCard(
                  title: 'Chemistry Quiz',
                  time: '10:42 PM',
                  participants: 38,
                  daysLeft: '5d',
                ),
                verticalSpace(12),
                _UpcomingExamCard(
                  title: 'Biology Final',
                  time: '10:42 PM',
                  participants: 52,
                  daysLeft: '7d',
                ),
                verticalSpace(32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _UpcomingExamCard extends StatelessWidget {
  final String title;
  final String time;
  final int participants;
  final String daysLeft;

  const _UpcomingExamCard({
    required this.title,
    required this.time,
    required this.participants,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: const Color(0xff00D3F2).withAlpha(20),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Feb',
                  style: TextStyle(
                    color: const Color(0xff00D3F2),
                    fontSize: 10.sp,
                  ),
                ),
                Text(
                  '9',
                  style: TextStyle(
                    color: const Color(0xff00D3F2),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.white16w400),
                verticalSpace(4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.white40,
                      size: 14.sp,
                    ),
                    horizontalSpace(4),
                    Text(time, style: AppTextStyles.white12w400alpha40),
                    horizontalSpace(12),
                    Icon(
                      Icons.groups_outlined,
                      color: AppColors.white40,
                      size: 14.sp,
                    ),
                    horizontalSpace(4),
                    Text(
                      '$participants',
                      style: AppTextStyles.white12w400alpha40,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.white5,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              daysLeft,
              style: AppTextStyles.white12w400alpha40.copyWith(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
