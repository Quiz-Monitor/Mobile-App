import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:examify/features/instructor/home/data/repo/instructor_home_repo.dart';
import 'package:examify/features/instructor/home/ui/widgets/live_exams.dart';
import 'package:examify/features/instructor/home/ui/widgets/state_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorHomeView extends StatefulWidget {
  const InstructorHomeView({super.key});

  @override
  State<InstructorHomeView> createState() => _InstructorHomeViewState();
}

class _InstructorHomeViewState extends State<InstructorHomeView> {
  late final Future<String> _displayNameFuture;
  late Future<ApiResult<InstructorDashboardDto>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _displayNameFuture = _getDisplayName();
    _dashboardFuture = _loadDashboard();
  }

  Future<ApiResult<InstructorDashboardDto>> _loadDashboard() {
    return getit<InstructorHomeRepo>().getDashboard();
  }

  Future<void> _refreshDashboard() async {
    final refreshedFuture = _loadDashboard();
    setState(() {
      _dashboardFuture = refreshedFuture;
    });
    await refreshedFuture;
  }

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

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _daysUntil(DateTime time) {
    final diff = time.difference(DateTime.now());
    if (diff.isNegative) {
      return 'Now';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours}h';
    }
    return '${diff.inMinutes.clamp(1, 59)}m';
  }

  List<ExamModel> _liveExams(List<ExamModel> exams) {
    final now = DateTime.now();
    final live = exams.where((exam) => exam.isLiveAt(now)).toList();
    live.sort((a, b) => a.endTime.compareTo(b.endTime));
    return live;
  }

  List<ExamModel> _upcomingExams(List<ExamModel> exams) {
    final now = DateTime.now();
    final upcoming = exams.where((exam) => exam.isUpcomingAt(now)).toList();
    upcoming.sort((a, b) => a.startTime.compareTo(b.startTime));
    return upcoming;
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.white16w400.copyWith(fontSize: 16.sp)),
        trailing ?? const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Text(message, style: AppTextStyles.white12w400alpha40),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: AppTextStyles.white12w400alpha40),
          verticalSpace(12),
          TextButton(
            onPressed: () {
              setState(() {
                _dashboardFuture = _loadDashboard();
              });
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingExamCard(ExamModel exam) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

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
                  months[exam.startTime.month - 1],
                  style: TextStyle(
                    color: const Color(0xff00D3F3),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  exam.startTime.day.toString(),
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
                  exam.title,
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
                      '${_formatTime(exam.startTime)} • ${exam.durationMinutes} mins',
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
              _daysUntil(exam.startTime),
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

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<ApiResult<InstructorDashboardDto>>(
          future: _dashboardFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return _buildLoadingState();
            }

            final result = snapshot.data;
            if (result == null) {
              return _buildLoadingState();
            }

            return RefreshIndicator(
              onRefresh: _refreshDashboard,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpace(8),
                      Text('Dashboard', style: AppTextStyles.white16w400),
                      FutureBuilder<String>(
                        future: _displayNameFuture,
                        builder: (context, nameSnapshot) {
                          final name = nameSnapshot.data ?? 'Instructor';
                          return Text(
                            'Welcome back,\t Dr.$name',
                            style: AppTextStyles.white14w400alpha70,
                          );
                        },
                      ),
                      verticalSpace(24),
                      result.when(
                        success: (dashboard) {
                          final liveExams = _liveExams(dashboard.exams);
                          final upcomingExams = _upcomingExams(dashboard.exams);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                    value: dashboard.totalExams.toString(),
                                    label: 'Total Exams',
                                    iconColor: const Color(0xff00B8DB),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xff51A2FF),
                                    iconUrl: 'assets/icons/live.svg',
                                    value: dashboard.liveNow.toString(),
                                    label: 'Live Now',
                                    iconColor: const Color(0xff2B7FFF),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xff05DF72),
                                    iconUrl: 'assets/icons/calendar.svg',
                                    value: dashboard.upcomingExams.toString(),
                                    label: 'Upcoming',
                                    iconColor: const Color(0xff00C950),
                                  ),
                                  StatCard(
                                    borderIconColor: const Color(0xffC27AFF),
                                    iconUrl: 'assets/icons/trend.svg',
                                    value: dashboard.completedExams.toString(),
                                    label: 'Completed',
                                    iconColor: const Color(0xffAD46FF),
                                  ),
                                ],
                              ),
                              verticalSpace(24),
                              _buildSectionHeader(
                                'Live Exams',
                                trailing: Container(
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
                                        '${liveExams.length} Active',
                                        style: TextStyle(
                                          color: const Color(0xff05DF72),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              verticalSpace(13),
                              if (liveExams.isEmpty)
                                _buildEmptyState('No live exams right now.')
                              else
                                Column(
                                  children: liveExams
                                      .take(2)
                                      .map(
                                        (exam) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 12.h,
                                          ),
                                          child: LiveExamCard(exam: exam),
                                        ),
                                      )
                                      .toList(),
                                ),
                              verticalSpace(24),
                              _buildSectionHeader(
                                'Upcoming Exams',
                                trailing: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'View All',
                                    style: TextStyle(
                                      color: const Color(0xff00D3F3),
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              ),
                              verticalSpace(12),
                              if (upcomingExams.isEmpty)
                                _buildEmptyState('No upcoming exams scheduled.')
                              else
                                Column(
                                  children: upcomingExams
                                      .take(3)
                                      .map(
                                        (exam) => Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 12.h,
                                          ),
                                          child: _buildUpcomingExamCard(exam),
                                        ),
                                      )
                                      .toList(),
                                ),
                              verticalSpace(32),
                            ],
                          );
                        },
                        failure: (error) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                childAspectRatio: 165.5 / 140,
                                children: [
                                  StatCard(
                                    borderIconColor: Color(0xff00D3F3),
                                    iconUrl: 'assets/icons/exams.svg',
                                    value: '--',
                                    label: 'Total Exams',
                                    iconColor: Color(0xff00B8DB),
                                  ),
                                  StatCard(
                                    borderIconColor: Color(0xff51A2FF),
                                    iconUrl: 'assets/icons/live.svg',
                                    value: '--',
                                    label: 'Live Now',
                                    iconColor: Color(0xff2B7FFF),
                                  ),
                                  StatCard(
                                    borderIconColor: Color(0xff05DF72),
                                    iconUrl: 'assets/icons/calendar.svg',
                                    value: '--',
                                    label: 'Upcoming',
                                    iconColor: Color(0xff00C950),
                                  ),
                                  StatCard(
                                    borderIconColor: Color(0xffC27AFF),
                                    iconUrl: 'assets/icons/trend.svg',
                                    value: '--',
                                    label: 'Completed',
                                    iconColor: Color(0xffAD46FF),
                                  ),
                                ],
                              ),
                              verticalSpace(24),
                              _buildErrorState(
                                error.apiErrorModel.getAllErrorMessages(),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
