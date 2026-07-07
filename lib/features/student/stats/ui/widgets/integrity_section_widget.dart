import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:examify/features/student/stats/ui/widgets/info_pill_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/integrity_badge_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/integrity_bar_widget.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntegritySectionWidget extends StatelessWidget {
  final IntegrityStatistics integrity;

  const IntegritySectionWidget({super.key, required this.integrity});

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: AppColors.white5,
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(color: AppColors.white10, width: 1.5),
  );

  @override
  Widget build(BuildContext context) {
    final total =
        (integrity.cleanExams + integrity.warningExams + integrity.flaggedExams)
            .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionLabel(
          text: 'Integrity Report',
          icon: Icons.security_rounded,
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(20.r),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: IntegrityBadge(
                      label: 'Clean',
                      count: integrity.cleanExams,
                      color: AppColors.mainGreen,
                      bgColor: AppColors.greenAlpha10,
                      icon: Icons.verified_rounded,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: IntegrityBadge(
                      label: 'Warning',
                      count: integrity.warningExams,
                      color: AppColors.brownText,
                      bgColor: AppColors.brown20alpha,
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: IntegrityBadge(
                      label: 'Flagged',
                      count: integrity.flaggedExams,
                      color: const Color(0xffFB2C36),
                      bgColor: AppColors.red5alpha,
                      icon: Icons.flag_rounded,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (total > 0)
                IntegrityBarWidget(integrity: integrity, total: total),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoPillWidget(
                    label: 'Total Violations',
                    value: integrity.totalViolationsAcrossAllExams.toString(),
                  ),
                  InfoPillWidget(
                    label: 'Avg per Exam',
                    value: integrity.averageViolationsPerExam.toStringAsFixed(
                      1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
