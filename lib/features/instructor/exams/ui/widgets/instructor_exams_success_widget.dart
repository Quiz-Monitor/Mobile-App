import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exam_card.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_filter_chips.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamsSuccessWidget extends StatelessWidget {
  final List<dynamic> exams;
  final List<dynamic> filteredExams;
  final Map<int, int> enrolledCounts;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ExamFilter selectedFilter;
  final ValueChanged<ExamFilter> onFilterChanged;
  final Future<void> Function() onRefresh;
  final void Function(dynamic) onExamTap;

  const InstructorExamsSuccessWidget({
    super.key,
    required this.exams,
    required this.filteredExams,
    required this.enrolledCounts,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.onRefresh,
    required this.onExamTap,
  });

  @override
  Widget build(BuildContext context) {
    final draftCount = exams.where((exam) => exam.isDraft == true).length;
    final liveCount = exams.where((exam) => exam.isLive == true).length;
    final upcomingCount = exams.where((exam) => exam.isUpcoming == true).length;
    final completedCount = exams
        .where((exam) => exam.isCompleted == true)
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exams', style: AppTextStyles.white20),
        InstructorExamsSearchBar(
          controller: searchController,
          onChanged: onSearchChanged,
        ),
        SizedBox(height: 18.h),
        InstructorExamsFilterChips(
          selectedFilter: selectedFilter,
          onFilterChanged: onFilterChanged,
          totalCount: exams.length,
          draftCount: draftCount,
          liveCount: liveCount,
          upcomingCount: upcomingCount,
          completedCount: completedCount,
        ),
        SizedBox(height: 12.h),
        Divider(color: AppColors.white10, thickness: 1.74.w),
        verticalSpace(12.h),
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primaryBlack,
            onRefresh: onRefresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: filteredExams.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final exam = filteredExams[index];
                return InstructorExamCard(
                  exam: exam,
                  isDraft: exam.isDraft,
                  isLive: exam.isLive,
                  isCompleted: exam.isCompleted,
                  enrolledCount: enrolledCounts[exam.examId] ?? 0,
                  onTap: () => onExamTap(exam),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
