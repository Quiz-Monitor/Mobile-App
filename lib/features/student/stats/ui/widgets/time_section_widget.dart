import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:examify/features/student/stats/ui/widgets/stats_section_label.dart';
import 'package:examify/features/student/stats/ui/widgets/time_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSectionWidget extends StatelessWidget {
  final TimeStatistics time;

  const TimeSectionWidget({super.key, required this.time});

  static String _formatSeconds(int seconds) {
    if (seconds == 0) return '0m';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionLabel(
          text: 'Time Statistics',
          icon: Icons.timer_rounded,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: TimeCardWidget(
                label: 'Average per Exam',
                value: _formatSeconds(time.averageTimeSpentSeconds),
                icon: Icons.access_time_rounded,
                color: AppColors.textblue,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TimeCardWidget(
                label: 'Total Time Spent',
                value: _formatSeconds(time.totalTimeSpentSeconds),
                icon: Icons.schedule_rounded,
                color: AppColors.mainIndego,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
