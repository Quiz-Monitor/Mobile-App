import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_cubit.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_state.dart';
import 'package:examify/features/student/stats/ui/widgets/integrity_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/overview_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/score_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_error_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_header_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/time_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentStatsView extends StatelessWidget {
  const StudentStatsView({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    context.read<StudentStatsCubit>().getStatistics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentStatsCubit, StudentStatsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryBlack,
          body: SafeArea(
            child: RefreshIndicator(
              color: Colors.white,
              backgroundColor: AppColors.white5,
              onRefresh: () => _onRefresh(context),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: StatsHeaderWidget()),
                  if (state is StudentStatsLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (state is StudentStatsFailure)
                    SliverFillRemaining(
                      child: StatsErrorWidget(message: state.errorMessage),
                    )
                  else if (state is StudentStatsSuccess)
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          OverviewSectionWidget(overview: state.stats.overview),
                          SizedBox(height: 20.h),
                          ScoreSectionWidget(
                            score: state.stats.scoreStatistics,
                          ),
                          SizedBox(height: 20.h),
                          IntegritySectionWidget(
                            integrity: state.stats.integrityStatistics,
                          ),
                          SizedBox(height: 20.h),
                          TimeSectionWidget(time: state.stats.timeStatistics),
                          SizedBox(height: 32.h),
                        ]),
                      ),
                    )
                  else
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff206DFD),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
