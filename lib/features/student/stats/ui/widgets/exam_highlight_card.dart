import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamHighlightCard extends StatelessWidget {
  final ExamHighlight exam;
  final String label;
  final Color color;
  final Color bgColor;

  const ExamHighlightCard({
    super.key,
    required this.exam,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withAlpha(60), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  exam.examTitle,
                  style: TextStyle(
                    color: Colors.white.withAlpha(220),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${exam.scorePercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${exam.finalScore.toStringAsFixed(0)} / ${exam.examTotalPoints.toStringAsFixed(0)} pts',
                style: TextStyle(
                  color: Colors.white.withAlpha(120),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
