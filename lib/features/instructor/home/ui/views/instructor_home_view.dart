import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/storage/session_storage.dart';

import 'package:examify/features/instructor/home/ui/widgets/live_exams.dart';
import 'package:examify/features/instructor/home/ui/widgets/state_card.dart';
import 'package:examify/features/instructor/home/logic/cubit/instructor_home_cubit.dart';
import 'package:examify/features/instructor/home/logic/cubit/instructor_home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InstructorHomeView extends StatelessWidget {
  const InstructorHomeView({super.key});

  Future<String> _getDisplayName() async {
    final storage = getit<SessionStorage>();
    final fullName = (await storage.getFullName())?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final email = (await storage.getEmail())?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Instructor';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getit<InstructorHomeCubit>()..getDashboard(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(8),
                  Text('Dashboard', style: AppTextStyles.white16w400),
                  FutureBuilder<String>(
                    future: _getDisplayName(),
                    builder: (context, snapshot) {
                      final name = snapshot.data ?? 'Instructor';
                      return Text(
                        'Welcome back, $name',
                        style: AppTextStyles.white14w400alpha70,
                      );
                    },
                  ),
                  verticalSpace(24),

                  BlocBuilder<InstructorHomeCubit, InstructorHomeState>(
                    builder: (context, state) {
                      if (state is InstructorHomeSuccess) {
                        final data = state.data;
                        debugPrint(
                          'liveExams length: ${data.liveExams.length}',
                        );

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    value: '${data.totalExamsCreated}',
                                    label: 'Total Exams',
                                    iconColor: const Color(0xff00B8DB),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xff51A2FF),
                                    iconUrl: 'assets/icons/students.svg',
                                    value: '${data.totalUniqueStudents}',
                                    label: 'Total Students',
                                    iconColor: const Color(0xff2B7FFF),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xff05DF72),
                                    iconUrl: 'assets/icons/live.svg',
                                    value: '${data.liveNow}',
                                    label: 'Live Now',
                                    iconColor: const Color(0xff00C950),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xffC27AFF),
                                    iconUrl: 'assets/icons/trend.svg',
                                    value:
                                        '${data.averageScorePercentage.toStringAsFixed(1)}%',
                                    label: 'Avg Score',
                                    iconColor: const Color(0xffAD46FF),
                                  ),
                                ],
                              ),

                              verticalSpace(24),

                              // Live Exams Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      color: const Color(
                                        0xff00C950,
                                      ).withAlpha(50),
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(
                                        width: 1.74.w,
                                        color: const Color(
                                          0xff00C950,
                                        ).withAlpha(75),
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
                                          '${data.liveNow} Active',
                                          style: TextStyle(
                                            color: const Color(0xff05DF72),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(13),
                              ...data.liveExams.map(
                                (exam) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: LiveExamCard(exam: exam),
                                ),
                              ),
                              if (data.liveExams.isEmpty)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Text(
                                    'No live exams at the moment.',
                                    style: AppTextStyles.white14w400alpha70,
                                  ),
                                ),

                              verticalSpace(24),

                              // Upcoming Exams Section
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Upcoming Exams',
                                    style: AppTextStyles.white16w400,
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
                              ...data.exams.where((e) => e.isUpcoming).take(3).map((
                                exam,
                              ) {
                                final daysLeft = exam.startTime
                                    .difference(DateTime.now())
                                    .inDays;
                                final timeStr =
                                    '${exam.startTime.hour}:${exam.startTime.minute.toString().padLeft(2, '0')}';
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: _UpcomingExamCard(
                                    title: exam.title,
                                    time: timeStr,
                                    participants: 0,
                                    daysLeft: daysLeft > 0
                                        ? '${daysLeft}d'
                                        : '<1d',
                                  ),
                                );
                              }),
                              if (!data.exams.any((e) => e.isUpcoming))
                                Text(
                                  'No upcoming exams.',
                                  style: AppTextStyles.white14w400alpha70,
                                ),
                              verticalSpace(32),
                            ],
                          ),
                        );
                      }
                      if (state is InstructorHomeLoading ||
                          state is InstructorHomeInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is InstructorHomeFailure) {
                        return Center(
                          child: Text(
                            state.message,
                            style: AppTextStyles.white16w400,
                          ),
                        );
                      }

                      final data = (state as InstructorHomeSuccess).data;
                      return Column(
                        children: [
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
                                value: '${data.totalExamsCreated}',
                                label: 'Total Exams',
                                iconColor: const Color(0xff00B8DB),
                              ),
                              StatCard(
                                borderIconColor: const Color(0xff51A2FF),
                                iconUrl: 'assets/icons/students.svg',
                                value: '${data.totalUniqueStudents}',
                                label: 'Total Students',
                                iconColor: const Color(0xff2B7FFF),
                              ),
                              StatCard(
                                borderIconColor: const Color(0xff05DF72),
                                iconUrl: 'assets/icons/live.svg',
                                value: '${data.liveNow}',
                                label: 'Live Now',
                                iconColor: const Color(0xff00C950),
                              ),
                              StatCard(
                                borderIconColor: const Color(0xffC27AFF),
                                iconUrl: 'assets/icons/trend.svg',
                                value:
                                    '${data.averageScorePercentage.toStringAsFixed(1)}%',
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
                                    color: const Color(
                                      0xff00C950,
                                    ).withAlpha(75),
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
                                      '${data.liveNow} Active',
                                      style: TextStyle(
                                        color: const Color(0xff05DF72),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          verticalSpace(13),
                          ...data.liveExams.map(
                            (exam) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: LiveExamCard(exam: exam),
                            ),
                          ),
                          if (data.liveExams.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Text(
                                'No live exams at the moment.',
                                style: AppTextStyles.white14w400alpha70,
                              ),
                            ),

                          verticalSpace(24),

                          // Upcoming Exams Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upcoming Exams',
                                style: AppTextStyles.white16w400,
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
                          ...data.exams.where((e) => e.isUpcoming).take(3).map((
                            exam,
                          ) {
                            final daysLeft = exam.startTime
                                .difference(DateTime.now())
                                .inDays;
                            final timeStr =
                                '${exam.startTime.hour}:${exam.startTime.minute.toString().padLeft(2, '0')}';
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _UpcomingExamCard(
                                title: exam.title,
                                time: timeStr,
                                participants: 0,
                                daysLeft: daysLeft > 0 ? '${daysLeft}d' : '<1d',
                              ),
                            );
                          }),
                          if (!data.exams.any((e) => e.isUpcoming))
                            Text(
                              'No upcoming exams.',
                              style: AppTextStyles.white14w400alpha70,
                            ),
                          verticalSpace(32),
                        ],
                      );
                    },
                  ),
                ],
              ),
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
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff00B8DB).withAlpha(50),
                  const Color(0xff2B7FFF).withAlpha(50),
                ],
              ),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xff00D3F3).withAlpha(75),
                width: 1.74.w,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Feb',
                  style: TextStyle(
                    color: const Color(0xff00D3F3),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '9',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
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
                Text(
                  title,
                  style: AppTextStyles.white16w400.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
                verticalSpace(6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.white60,
                      size: 16.sp,
                    ),
                    horizontalSpace(6),
                    Text(
                      time,
                      style: AppTextStyles.white12w400alpha40.copyWith(
                        color: AppColors.white60,
                      ),
                    ),
                    horizontalSpace(16),
                    SizedBox(
                      width: 12.w,
                      height: 12.w,
                      child: SvgPicture.asset(
                        'assets/icons/students.svg',
                        colorFilter: ColorFilter.mode(
                          AppColors.white60,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    horizontalSpace(6),
                    Text(
                      '$participants',
                      style: AppTextStyles.white12w400alpha40.copyWith(
                        color: AppColors.white60,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 40.w,
            height: 40.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.white5,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.white10, width: 1.74.w),
            ),
            child: Text(
              daysLeft,
              style: AppTextStyles.white12w400alpha40.copyWith(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
