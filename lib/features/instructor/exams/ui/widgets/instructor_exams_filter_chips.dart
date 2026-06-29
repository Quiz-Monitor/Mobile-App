import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamsFilterChips extends StatelessWidget {
  const InstructorExamsFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.totalCount,
    required this.liveCount,
    required this.upcomingCount,
    required this.completedCount,
  });

  final ExamFilter selectedFilter;
  final ValueChanged<ExamFilter> onFilterChanged;
  final int totalCount;
  final int liveCount;
  final int upcomingCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChipItem(
            label: 'All',
            count: totalCount,
            isSelected: selectedFilter == ExamFilter.all,
            onTap: () => onFilterChanged(ExamFilter.all),
          ),
          horizontalSpace(14.w),
          _FilterChipItem(
            label: 'Live',
            count: liveCount,
            isSelected: selectedFilter == ExamFilter.live,
            onTap: () => onFilterChanged(ExamFilter.live),
          ),
          horizontalSpace(14.w),
          _FilterChipItem(
            label: 'Upcoming',
            count: upcomingCount,
            isSelected: selectedFilter == ExamFilter.upcoming,
            onTap: () => onFilterChanged(ExamFilter.upcoming),
          ),
          horizontalSpace(14.w),
          _FilterChipItem(
            label: 'Completed',
            count: completedCount,
            isSelected: selectedFilter == ExamFilter.completed,
            onTap: () => onFilterChanged(ExamFilter.completed),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainBlue : AppColors.white5,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.mainBlue : AppColors.white10,
            width: 1.74.w,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.white60,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
