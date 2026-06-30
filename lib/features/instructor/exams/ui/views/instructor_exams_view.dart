import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_cubit.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_state.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exam_details_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_empty_state.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_error_state.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_skeleton_list.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_success_widget.dart';
import 'package:examify/features/instructor/exams/ui/widgets/upcoming_exam_options_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ExamFilter { all, draft, live, upcoming, completed }

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
        case ExamFilter.draft:
          return exam.isDraft == true;
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
                  failure: (message) => InstructorExamsErrorState(
                    message: message,
                    onRefresh: () => _refreshExams(context),
                  ),
                  success: (exams, enrolledCounts) {
                    if (exams.isEmpty) {
                      return InstructorExamsEmptyState(
                        onRefresh: () => _refreshExams(context),
                      );
                    }

                    final searchedExams = _filterExams(exams);
                    final filteredExams = _applyExamFilter(searchedExams);
                    return InstructorExamsSuccessWidget(
                      exams: exams,
                      filteredExams: filteredExams,
                      enrolledCounts: enrolledCounts,
                      searchController: _searchController,
                      onSearchChanged: (value) =>
                          setState(() => _searchQuery = value),
                      selectedFilter: _selectedFilter,
                      onFilterChanged: (filter) =>
                          setState(() => _selectedFilter = filter),
                      onRefresh: () => _refreshExams(context),
                      onExamTap: (exam) => _handleExamTap(context, exam),
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
    if (exam.isDraft) {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.primaryBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => UpcomingExamOptionsBottomSheet(
          exam: exam,
          onPublishSuccess: () => _refreshExams(context),
        ),
      );
    } else if (exam.isUpcoming) {
      Navigator.pushNamed(
        context,
        Routes.manageQuestionsScreen,
        arguments: exam,
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => InstructorExamDetailsView(exam: exam),
        ),
      );
    }
  }
}
