import 'dart:math' as math;

import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/stats/data/models/instructor_statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorScoreSection extends StatelessWidget {
  final InstructorScoreStatistics score;

  const InstructorScoreSection({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Score Statistics',
          style: AppTextStyles.white16w400.copyWith(fontSize: 16.sp),
        ),
        verticalSpace(12),

        // Average + Pass Rate card
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.white5,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.white10, width: 1.74.w),
          ),
          child: Row(
            children: [
              _CircularScore(
                percentage: score.averageScorePercentage,
                label: 'Average',
              ),
              horizontalSpace(20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MetricRow(
                      icon: Icons.done_all_rounded,
                      label: 'Pass Rate',
                      value: '${score.passRate.toStringAsFixed(1)}%',
                      color: score.passRate >= 50
                          ? const Color(0xff00C950)
                          : const Color(0xffFB2C36),
                    ),
                    verticalSpace(14),
                    _MetricRow(
                      icon: Icons.equalizer_rounded,
                      label: 'Avg Score',
                      value:
                          '${score.averageScorePercentage.toStringAsFixed(1)}%',
                      color: AppColors.blueBorder,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        verticalSpace(12),

        // Best exam
        if (score.highestAverageExam != null &&
            score.highestAverageExam!.examTitle != 'N/A')
          _ExamHighlightCard(
            exam: score.highestAverageExam!,
            label: '🏆 Highest Average Exam',
            color: const Color(0xff00C950),
            borderColor: const Color(0xff05DF72),
          ),

        if (score.highestAverageExam != null &&
            score.highestAverageExam!.examTitle != 'N/A')
          verticalSpace(12),

        // Worst exam
        if (score.lowestAverageExam != null &&
            score.lowestAverageExam!.examTitle != 'N/A')
          _ExamHighlightCard(
            exam: score.lowestAverageExam!,
            label: '📉 Lowest Average Exam',
            color: const Color(0xffFB2C36),
            borderColor: const Color(0xffFB2C36),
          ),
      ],
    );
  }
}

// ── Circular Score ──────────────────────────────────────────────────

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 7.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi,
      false,
      Paint()
        ..color = trackColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcPainter old) =>
      old.progress != progress || old.color != color;
}

class _CircularScore extends StatelessWidget {
  final double percentage;
  final String label;

  const _CircularScore({required this.percentage, required this.label});

  @override
  Widget build(BuildContext context) {
    final clamped = percentage.clamp(0.0, 100.0);
    final Color arcColor;
    if (clamped >= 70) {
      arcColor = const Color(0xff05DF72);
    } else if (clamped >= 40) {
      arcColor = AppColors.brownText;
    } else {
      arcColor = const Color(0xffFB2C36);
    }

    return SizedBox(
      width: 90,
      height: 90,
      child: CustomPaint(
        painter: _ArcPainter(
          progress: clamped / 100,
          color: arcColor,
          trackColor: AppColors.white10,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${clamped.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(100),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Metric Row ──────────────────────────────────────────────────────

class _MetricRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _MetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: color.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 14.r),
        ),
        horizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withAlpha(100),
                  fontSize: 11.sp,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Exam Highlight Card ─────────────────────────────────────────────

class _ExamHighlightCard extends StatelessWidget {
  final InstructorExamHighlight exam;
  final String label;
  final Color color;
  final Color borderColor;

  const _ExamHighlightCard({
    required this.exam,
    required this.label,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor.withAlpha(60), width: 1.74.w),
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
                verticalSpace(4),
                Text(
                  exam.examTitle,
                  style: AppTextStyles.white16w400.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${exam.averageScorePercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${exam.attemptCount} attempts',
                style: AppTextStyles.white12w400alpha40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
