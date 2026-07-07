import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/stats/data/models/instructor_statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorIntegritySection extends StatelessWidget {
  final InstructorIntegrityStatistics integrity;

  const InstructorIntegritySection({super.key, required this.integrity});

  @override
  Widget build(BuildContext context) {
    final total =
        (integrity.cleanAttempts +
                integrity.warningAttempts +
                integrity.flaggedAttempts)
            .toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Integrity Report',
          style: AppTextStyles.white16w400.copyWith(fontSize: 16.sp),
        ),
        verticalSpace(12),
        Container(
          padding: EdgeInsets.all(18.r),
          decoration: BoxDecoration(
            color: AppColors.white5,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.white10, width: 1.74.w),
          ),
          child: Column(
            children: [
              // Badge row
              Row(
                children: [
                  Expanded(
                    child: _BadgeCard(
                      label: 'Clean',
                      count: integrity.cleanAttempts,
                      color: const Color(0xff00C950),
                      bgColor: const Color(0xff00C950).withAlpha(25),
                      borderColor: const Color(0xff05DF72),
                      icon: Icons.verified_rounded,
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: _BadgeCard(
                      label: 'Warning',
                      count: integrity.warningAttempts,
                      color: const Color(0xffFDC700),
                      bgColor: const Color(0xffF0B100).withAlpha(25),
                      borderColor: const Color(0xffFDC700),
                      icon: Icons.warning_amber_rounded,
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: _BadgeCard(
                      label: 'Flagged',
                      count: integrity.flaggedAttempts,
                      color: const Color(0xffFB2C36),
                      bgColor: const Color(0xffFB2C36).withAlpha(15),
                      borderColor: const Color(0xffFB2C36),
                      icon: Icons.flag_rounded,
                    ),
                  ),
                ],
              ),

              verticalSpace(16),

              // Distribution bar
              if (total > 0)
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: SizedBox(
                    height: 8.h,
                    child: Row(
                      children: [
                        if (integrity.cleanAttempts > 0)
                          Expanded(
                            flex: (integrity.cleanAttempts / total * 1000)
                                .round(),
                            child: Container(color: const Color(0xff05DF72)),
                          ),
                        if (integrity.warningAttempts > 0)
                          Expanded(
                            flex: (integrity.warningAttempts / total * 1000)
                                .round(),
                            child: Container(color: AppColors.brownText),
                          ),
                        if (integrity.flaggedAttempts > 0)
                          Expanded(
                            flex: (integrity.flaggedAttempts / total * 1000)
                                .round(),
                            child: Container(color: const Color(0xffFB2C36)),
                          ),
                      ],
                    ),
                  ),
                ),

              verticalSpace(16),

              // Info pills
              Row(
                children: [
                  Expanded(
                    child: _InfoPill(
                      label: 'Total Violations',
                      value: integrity.totalViolationsAcrossAllExams.toString(),
                    ),
                  ),
                  horizontalSpace(12),
                  Expanded(
                    child: _InfoPill(
                      label: 'Avg / Attempt',
                      value: integrity.averageViolationsPerAttempt
                          .toStringAsFixed(1),
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

// ── Badge Card ─────────────────────────────────────────────────────

class _BadgeCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bgColor;
  final Color borderColor;
  final IconData icon;

  const _BadgeCard({
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
    required this.borderColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor.withAlpha(60), width: 1.5.w),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18.r),
          verticalSpace(4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: AppTextStyles.white12w400alpha40.copyWith(fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Pill ────────────────────────────────────────────────────────

class _InfoPill extends StatelessWidget {
  final String label;
  final String value;

  const _InfoPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.white10, width: 1.5.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.white12w400alpha40.copyWith(fontSize: 11.sp),
          ),
          verticalSpace(2),
          Text(
            value,
            style: AppTextStyles.white16w400.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
