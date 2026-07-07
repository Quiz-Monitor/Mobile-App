import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:examify/features/student/stats/ui/widgets/stat_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'stats_section_label.dart';

class OverviewSectionWidget extends StatelessWidget {
  final OverviewStats overview;

  const OverviewSectionWidget({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatsSectionLabel(
          text: 'Overview',
          icon: Icons.bar_chart_rounded,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: StatCardWidget(
                value: overview.totalExamsSubmitted.toString(),
                label: 'Submitted',
                icon: Icons.send_rounded,
                gradient: StatCardGradients.submitted,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: StatCardWidget(
                value: overview.totalExamsGraded.toString(),
                label: 'Graded',
                icon: Icons.check_circle_rounded,
                gradient: StatCardGradients.graded(),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: StatCardWidget(
                value: overview.totalExamsPendingGrading.toString(),
                label: 'Pending',
                icon: Icons.hourglass_top_rounded,
                gradient: StatCardGradients.pending(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
