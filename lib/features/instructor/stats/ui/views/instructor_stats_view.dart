import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/stats/logic/cubit/instructor_stats_cubit.dart';
import 'package:examify/features/instructor/stats/logic/cubit/instructor_stats_state.dart';
import 'package:examify/features/instructor/stats/ui/widgets/exam_overview_section.dart';
import 'package:examify/features/instructor/stats/ui/widgets/instructor_integrity_section.dart';
import 'package:examify/features/instructor/stats/ui/widgets/instructor_score_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorStatsView extends StatelessWidget {
  const InstructorStatsView({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<InstructorStatsCubit>().getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstructorStatsCubit, InstructorStatsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBlack,
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: AppColors.white5,
              onRefresh: () => _onRefresh(context),
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
                      Text('Statistics', style: AppTextStyles.white16w400),
                      Text(
                        'Your teaching performance at a glance',
                        style: AppTextStyles.white14w400alpha70,
                      ),
                      verticalSpace(24),
                      if (state is InstructorStatsLoading)
                        SizedBox(
                          height: 400.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      else if (state is InstructorStatsFailure)
                        _ErrorContent(message: state.errorMessage)
                      else if (state is InstructorStatsSuccess) ...[
                        ExamOverviewSection(
                          overview: state.stats.examOverview,
                          studentOverview: state.stats.studentOverview,
                        ),
                        verticalSpace(24),
                        InstructorScoreSection(
                          score: state.stats.scoreStatistics,
                        ),
                        verticalSpace(24),
                        InstructorIntegritySection(
                          integrity: state.stats.integrityStatistics,
                        ),
                        verticalSpace(32),
                      ] else
                        SizedBox(
                          height: 400.h,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff206DFD),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;

  const _ErrorContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.greyText, size: 48.r),
          verticalSpace(12),
          Text('Failed to load statistics', style: AppTextStyles.white16w400),
          verticalSpace(8),
          Text(
            message,
            style: AppTextStyles.white12w400alpha60,
            textAlign: TextAlign.center,
          ),
          verticalSpace(20),
          GestureDetector(
            onTap: () => context.read<InstructorStatsCubit>().getStatistics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.blueBorder,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.white16w400.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
