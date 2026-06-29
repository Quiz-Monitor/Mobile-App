import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_cubit.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_state.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exam_details_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exam_card.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_filter_chips.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_search_bar.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_skeleton_list.dart';
import 'package:examify/features/instructor/exams/ui/widgets/upcoming_exam_options_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ExamFilter { all, live, upcoming, completed }

class InstructorExamsView extends StatefulWidget {
  const InstructorExamsView({super.key});

  @override
  State<InstructorExamsView> createState() => _InstructorExamsViewState();
}

class _InstructorExamsViewState extends State<InstructorExamsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ExamFilter _selectedFilter = ExamFilter.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshExams(BuildContext context) async {
    await context.read<ExamsCubit>().getInstructorExams(showLoading: false);
  }

  List<dynamic> _filterExams(List<dynamic> exams) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return exams;

    return exams.where((exam) {
      final title = exam.title.toString().toLowerCase();
      final code = exam.examCode.toString().toLowerCase();
      final description = exam.description.toString().toLowerCase();
      return title.contains(query) ||
          code.contains(query) ||
          description.contains(query);
    }).toList();
  }

  List<dynamic> _applyExamFilter(List<dynamic> exams) {
    return exams.where((exam) {
      switch (_selectedFilter) {
        case ExamFilter.all:
          return true;
        case ExamFilter.live:
          return exam.isLive == true;
        case ExamFilter.upcoming:
          return exam.isUpcoming == true;
        case ExamFilter.completed:
          return exam.isCompleted == true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit<ExamsCubit>()..getInstructorExams(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, Routes.createExamScreen);
          },
          backgroundColor: AppColors.mainBlue,
          label: Text(
            '+ Create Exam',
            style: AppTextStyles.white16w400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: BlocBuilder<ExamsCubit, ExamsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const InstructorExamsSkeletonList(),
                  initial: () => const InstructorExamsSkeletonList(),
                  failure: (message) => _buildErrorState(context, message),
                  success: (exams, enrolledCounts) {
                    if (exams.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    final searchedExams = _filterExams(exams);
                    final filteredExams = _applyExamFilter(searchedExams);
                    final liveCount = exams
                        .where((exam) => exam.isLive == true)
                        .length;
                    final upcomingCount = exams
                        .where((exam) => exam.isUpcoming == true)
                        .length;
                    final completedCount = exams
                        .where((exam) => exam.isCompleted == true)
                        .length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Exams', style: AppTextStyles.white20),
                        InstructorExamsSearchBar(
                          controller: _searchController,
                          onChanged: (value) =>
                              setState(() => _searchQuery = value),
                        ),
                        SizedBox(height: 18.h),
                        InstructorExamsFilterChips(
                          selectedFilter: _selectedFilter,
                          onFilterChanged: (filter) =>
                              setState(() => _selectedFilter = filter),
                          totalCount: exams.length,
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
                            onRefresh: () => _refreshExams(context),
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              itemCount: filteredExams.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                final exam = filteredExams[index];
                                final isLive = exam.isLive;
                                final isCompleted = exam.isCompleted;
                                final enrolledCount =
                                    enrolledCounts[exam.examId] ?? 0;

                                return InstructorExamCard(
                                  exam: exam,
                                  isLive: isLive,
                                  isCompleted: isCompleted,
                                  enrolledCount: enrolledCount,
                                  onTap: () => _handleExamTap(context, exam),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  orElse: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _handleExamTap(BuildContext context, dynamic exam) {
    if (exam.isUpcoming) {
      if (exam.isPublished) {
        Navigator.pushNamed(
          context,
          Routes.manageQuestionsScreen,
          arguments: exam,
        );
      } else {
        showModalBottomSheet(
          context: context,
          builder: (context) => UpcomingExamOptionsBottomSheet(
            exam: exam,
            onPublishSuccess: () => _refreshExams(context),
          ),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstructorExamDetailsView(exam: exam),
        ),
      );
    }
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return RefreshIndicator(
      color: AppColors.mainBlue,
      onRefresh: () => _refreshExams(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(height: 140.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(
              child: Text(
                message,
                style: AppTextStyles.white20,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshExams(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(height: 140.h),
          Center(
            child: Text(
              'There are no exams yet.\nPull down to refresh.',
              style: AppTextStyles.white20,
            ),
          ),
        ],
      ),
    );
  }
}
