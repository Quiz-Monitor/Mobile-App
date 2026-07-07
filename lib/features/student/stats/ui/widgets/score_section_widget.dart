import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:examify/features/student/stats/ui/widgets/circular_score_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/exam_highlight_card.dart';
import 'package:examify/features/student/stats/ui/widgets/score_row_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreSectionWidget extends StatelessWidget {
  final ScoreStatistics score;

  const ScoreSectionWidget({super.key, required this.score});

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white5,
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(color: AppColors.white10, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionLabel(
          text: 'Score Statistics',
          icon: Icons.scoreboard_rounded,
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              CircularScoreWidget(
                percentage: score.averageScorePercentage,
                label: 'Average',
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScoreRowWidget(
                      label: 'Highest',
                      value:
                          '${score.highestScorePercentage.toStringAsFixed(1)}%',
                      color: AppColors.mainGreen,
                      icon: Icons.trending_up_rounded,
                    ),
                    SizedBox(height: 12.h),
                    ScoreRowWidget(
                      label: 'Lowest',
                      value:
                          '${score.lowestScorePercentage.toStringAsFixed(1)}%',
                      color: const Color(0xffFB2C36),
                      icon: Icons.trending_down_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        if (score.highestScoringExam != null)
          ExamHighlightCard(
            exam: score.highestScoringExam!,
            label: '🏆 Best Exam',
            color: AppColors.mainGreen,
            bgColor: AppColors.greenAlpha10,
          ),
        SizedBox(height: 10.h),
        if (score.lowestScoringExam != null)
          ExamHighlightCard(
            exam: score.lowestScoringExam!,
            label: '📉 Needs Improvement',
            color: const Color(0xffFB2C36),
            bgColor: AppColors.red5alpha,
          ),
      ],
    );
  }
}
