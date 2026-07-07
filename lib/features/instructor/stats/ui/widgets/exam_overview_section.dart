import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/stats/data/models/instructor_statistics_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamOverviewSection extends StatelessWidget {
  final ExamOverview overview;
  final StudentOverview studentOverview;

  const ExamOverviewSection({
    super.key,
    required this.overview,
    required this.studentOverview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Exam Stats Grid ──
        _SectionHeader(title: 'Exam Overview'),
        verticalSpace(12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 165.5 / 130,
          children: [
            _OverviewCard(
              icon: Icons.create_rounded,
              iconColor: const Color(0xff00B8DB),
              borderColor: const Color(0xff00D3F3),
              value: overview.totalExamsCreated.toString(),
              label: 'Created',
            ),
            _OverviewCard(
              icon: Icons.publish_rounded,
              iconColor: const Color(0xff2B7FFF),
              borderColor: const Color(0xff51A2FF),
              value: overview.totalExamsPublished.toString(),
              label: 'Published',
            ),
            _OverviewCard(
              icon: Icons.drafts_rounded,
              iconColor: const Color(0xffE09900),
              borderColor: const Color(0xffFDC700),
              value: overview.totalExamsDraft.toString(),
              label: 'Drafts',
            ),
            _OverviewCard(
              icon: Icons.people_alt_rounded,
              iconColor: const Color(0xffAD46FF),
              borderColor: const Color(0xffC27AFF),
              value: overview.totalExamsWithAttempts.toString(),
              label: 'With Attempts',
            ),
          ],
        ),

        verticalSpace(24),

        // ── Student Stats Grid ──
        _SectionHeader(title: 'Student Overview'),
        verticalSpace(12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 165.5 / 130,
          children: [
            _OverviewCard(
              icon: Icons.person_rounded,
              iconColor: const Color(0xff00B8DB),
              borderColor: const Color(0xff00D3F3),
              value: studentOverview.totalUniqueStudents.toString(),
              label: 'Students',
            ),
            _OverviewCard(
              icon: Icons.assignment_turned_in_rounded,
              iconColor: const Color(0xff2B7FFF),
              borderColor: const Color(0xff51A2FF),
              value: studentOverview.totalAttempts.toString(),
              label: 'Attempts',
            ),
            _OverviewCard(
              icon: Icons.check_circle_rounded,
              iconColor: const Color(0xff00C950),
              borderColor: const Color(0xff05DF72),
              value: studentOverview.totalGradedAttempts.toString(),
              label: 'Graded',
            ),
            _OverviewCard(
              icon: Icons.hourglass_top_rounded,
              iconColor: const Color(0xffE09900),
              borderColor: const Color(0xffFDC700),
              value: studentOverview.totalPendingGradingAttempts.toString(),
              label: 'Pending',
            ),
          ],
        ),
      ],
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.white16w400.copyWith(fontSize: 16.sp),
    );
  }
}

// ── Overview Card ──────────────────────────────────────────────────
// Matches the dashboard StatCard visual language:
// white2 bg, rounded 14, icon badge circle, big value + muted label.

class _OverviewCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final String value;
  final String label;

  const _OverviewCard({
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor.withAlpha(75),
                width: 1.7.w,
              ),
              color: iconColor.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18.r),
          ),
          const Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
            ),
          ),
          Text(label, style: AppTextStyles.white12w400alpha40),
        ],
      ),
    );
  }
}
