import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/student/stats/data/models/student_statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntegrityBarWidget extends StatelessWidget {
  final IntegrityStatistics integrity;
  final double total;

  const IntegrityBarWidget({
    super.key,
    required this.integrity,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cleanFrac = integrity.cleanExams / total;
    final warnFrac = integrity.warningExams / total;
    final flagFrac = integrity.flaggedExams / total;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: SizedBox(
        height: 10.h,
        child: Row(
          children: [
            if (cleanFrac > 0)
              Expanded(
                flex: (cleanFrac * 1000).round(),
                child: Container(color: AppColors.mainGreen),
              ),
            if (warnFrac > 0)
              Expanded(
                flex: (warnFrac * 1000).round(),
                child: Container(color: AppColors.brownText),
              ),
            if (flagFrac > 0)
              Expanded(
                flex: (flagFrac * 1000).round(),
                child: Container(color: const Color(0xffFB2C36)),
              ),
          ],
        ),
      ),
    );
  }
}
