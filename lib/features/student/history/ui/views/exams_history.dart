import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/history/data/models/exams_history_model.dart';
import 'package:examify/features/student/history/logic/cubit/student_results_cubit.dart';
import 'package:examify/features/student/history/logic/cubit/student_results_state.dart';
import 'package:examify/features/student/history/ui/widgets/custom_evaluation_card.dart';
import 'package:examify/features/student/history/ui/widgets/custom_exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExamsHistory extends StatelessWidget {
  const ExamsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<StudentResultsCubit>().getExamHistory();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Exams History', style: AppTextStyles.white20),
                SizedBox(height: 40.h),
                BlocBuilder<StudentResultsCubit, StudentResultsState>(
                  builder: (context, state) {
                    List<ExamsHistoryModel> exams = [];
                    bool isLoading = false;

                    if (state is StudentResultsLoading ||
                        state is StudentResultsInitial) {
                      isLoading = true;
                      // Dummy data for skeleton
                      exams = List.generate(
                        4,
                        (index) => ExamsHistoryModel(
                          examTitle: 'Loading Exam...',
                          status: 'Pending',
                        ),
                      );
                    } else if (state is StudentResultsSuccess) {
                      exams = state.exams;
                    }

                    // Calculate stats
                    int totalExams = exams.length;
                    int passedExams = isLoading
                        ? 0
                        : exams.where((e) {
                            if (e.finalScore == null ||
                                e.examTotalPoints == null) {
                              return false;
                            }
                            return e.finalScore! >= (e.examTotalPoints! / 2);
                          }).length;

                    double avgScore = 0;
                    if (!isLoading && totalExams > 0) {
                      int totalScores = exams.fold(
                        0,
                        (sum, e) => sum + (e.finalScore ?? 0),
                      );
                      int maxPoints = exams.fold(
                        0,
                        (sum, e) => sum + (e.examTotalPoints ?? 100),
                      ); // Default 100 per exam if null

                      if (maxPoints > 0) {
                        avgScore = (totalScores / maxPoints) * 100;
                      }
                    }

                    return Column(
                      children: [
                        Skeletonizer(
                          enabled: isLoading,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomEvaluationCard(
                                title: '$totalExams',
                                subTitle: 'Total',
                              ),
                              CustomEvaluationCard(
                                title: '$passedExams',
                                subTitle: 'Passed',
                              ),
                              CustomEvaluationCard(
                                title: isLoading
                                    ? '0%'
                                    : '${avgScore.toStringAsFixed(0)}%',
                                subTitle: 'Avg Score',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28.h),
                        if (state is StudentResultsFailure)
                          Center(
                            child: Text(
                              state.message,
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        else if (state is StudentResultsEmpty)
                          Expanded(
                            child: Center(
                              child: Text(
                                'No previous exams',
                                style: AppTextStyles.white16w400,
                              ),
                            ),
                          )
                        else
                          Skeletonizer(
                            enabled: isLoading,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: exams.length,
                              itemBuilder: (context, index) {
                                return CustomExamCard(
                                  exHistoryModel: exams[index],
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
