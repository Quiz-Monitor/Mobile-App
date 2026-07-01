import 'dart:ui';

import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_cubit.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_state.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exam_details_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_empty_state.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_error_state.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_skeleton_list.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exams_success_widget.dart';

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
                      onDeleteTap: (exam) => _handleDeleteExam(context, exam),
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
      Navigator.pushNamed(
        context,
        Routes.draftExamManagementScreen,
        arguments: exam,
      ).then((result) {
        if (result == true) _refreshExams(context);
      });
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

  Future<void> _handleDeleteExam(BuildContext context, dynamic exam) async {
    final cubit = context.read<ExamsCubit>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool isDeleting = false;
        bool isSuccess = false;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: AppColors.primaryBlack,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(color: AppColors.white10, width: 1.74.w),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? AppColors.mainGreen.withAlpha(30)
                              : const Color(0xffFB2C36).withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            isSuccess
                                ? Icons.check_circle_outline_rounded
                                : Icons.delete_outline_rounded,
                            key: ValueKey(isSuccess),
                            color: isSuccess
                                ? AppColors.mainGreen
                                : const Color(0xffFB2C36),
                            size: 32.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        isSuccess ? 'Deleted!' : 'Delete Exam?',
                        style: AppTextStyles.white16w400.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        isSuccess
                            ? 'The exam has been successfully deleted.'
                            : 'This action cannot be undone. All your exam data will be permanently deleted.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.whit14w400alpha60.copyWith(
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          if (!isSuccess) ...[
                            Expanded(
                              child: InkWell(
                                onTap: isDeleting
                                    ? null
                                    : () => Navigator.pop(dialogContext),
                                borderRadius: BorderRadius.circular(12.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.white5,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: AppTextStyles.white16w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                          ],
                          Expanded(
                            child: InkWell(
                              onTap: (isDeleting || isSuccess)
                                  ? null
                                  : () async {
                                      setState(() => isDeleting = true);
                                      final result = await cubit.deleteExam(
                                        exam.examId,
                                      );

                                      if (result is Success) {
                                        setState(() {
                                          isDeleting = false;
                                          isSuccess = true;
                                        });
                                        await Future.delayed(
                                          const Duration(milliseconds: 1500),
                                        );
                                        if (dialogContext.mounted) {
                                          Navigator.pop(dialogContext);
                                        }
                                      } else {
                                        setState(() => isDeleting = false);
                                      }
                                    },
                              borderRadius: BorderRadius.circular(12.r),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: isSuccess
                                      ? AppColors.mainGreen
                                      : const Color(0xffFB2C36),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: isDeleting
                                      ? SizedBox(
                                          height: 20.sp,
                                          width: 20.sp,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.w,
                                          ),
                                        )
                                      : isSuccess
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'Delete',
                                          style: AppTextStyles.white16w400
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
