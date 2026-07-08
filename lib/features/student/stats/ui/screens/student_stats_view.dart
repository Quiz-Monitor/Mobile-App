import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_cubit.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_state.dart';
import 'package:examify/features/student/stats/ui/widgets/integrity_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/overview_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/score_section_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_error_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/time_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StudentStatsView extends StatelessWidget {
  const StudentStatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentStatsCubit, StudentStatsState>(
      builder: (context, state) {
        bool isLoading =
            state is StudentStatsLoading || state is StudentStatsInitial;

        StudentStatisticsModel? stats;

        if (isLoading) {
          stats = StudentStatisticsModel(
            overview: OverviewStats(
              totalExamsSubmitted: 10,
              totalExamsGraded: 10,
              totalExamsPendingGrading: 0,
            ),
            scoreStatistics: ScoreStatistics(
              averageScorePercentage: 85,
              highestScorePercentage: 100,
              lowestScorePercentage: 70,
              highestScoringExam: ExamHighlight(
                examTitle: 'Loading Data...',
                scorePercentage: 100,
                finalScore: 100,
                examTotalPoints: 100,
              ),
              lowestScoringExam: ExamHighlight(
                examTitle: 'Loading Data...',
                scorePercentage: 70,
                finalScore: 70,
                examTotalPoints: 100,
              ),
            ),
            integrityStatistics: IntegrityStatistics(
              totalViolationsAcrossAllExams: 2,
              averageViolationsPerExam: 0.2,
              cleanExams: 8,
              warningExams: 1,
              flaggedExams: 1,
            ),
            timeStatistics: TimeStatistics(
              averageTimeSpentSeconds: 3600,
              totalTimeSpentSeconds: 36000,
            ),
          );
        } else if (state is StudentStatsSuccess) {
          stats = state.stats;
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: RefreshIndicator(
            color: AppColors.mainBlue,
            onRefresh: () async {
              await context.read<StudentStatsCubit>().getStatistics();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SafeArea(
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('My Statistics', style: AppTextStyles.white20),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                    if (state is StudentStatsFailure)
                      SliverFillRemaining(
                        child: Padding(
                          padding: EdgeInsets.only(top: 80.h),
                          child: StatsErrorWidget(message: state.errorMessage),
                        ),
                      )
                    else if (stats != null)
                      SliverList(
                        delegate: SliverChildListDelegate([
                          Skeletonizer(
                            enabled: isLoading,
                            child: OverviewSectionWidget(
                              overview: stats.overview,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Skeletonizer(
                            enabled: isLoading,
                            child: ScoreSectionWidget(
                              score: stats.scoreStatistics,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Skeletonizer(
                            enabled: isLoading,
                            child: IntegritySectionWidget(
                              integrity: stats.integrityStatistics,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Skeletonizer(
                            enabled: isLoading,
                            child: TimeSectionWidget(
                              time: stats.timeStatistics,
                            ),
                          ),
                          SizedBox(height: 32.h),
                        ]),
                      )
                    else
                      const SliverFillRemaining(child: SizedBox.shrink()),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
