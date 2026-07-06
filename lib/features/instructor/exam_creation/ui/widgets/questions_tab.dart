import 'dart:ui';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class QuestionsTab extends StatelessWidget {
  final int examId;
  final void Function({QuestionLocalDto? initialQuestion}) onAddQuestion;

  const QuestionsTab({
    super.key,
    required this.examId,
    required this.onAddQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCreationCubit, ExamCreationState>(
      builder: (context, state) {
        if (state is QuestionsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.white90),
          );
        }

        if (state is ExamCreationError &&
            context.read<ExamCreationCubit>().addedQuestions.isEmpty) {
          return _buildErrorState(context, state.message);
        }

        final questions = context.read<ExamCreationCubit>().addedQuestions;

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () =>
                  context.read<ExamCreationCubit>().loadExamQuestions(examId),
              color: AppColors.mainBlue,
              child: questions.isEmpty
                  ? _buildEmptyState(context)
                  : _buildQuestionsList(questions, context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.redAccent.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 48.sp,
              ),
            ),
            verticalSpace(16.h),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.white20.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(8.h),
            Text(
              message,
              style: AppTextStyles.white16w400.copyWith(
                color: AppColors.white60,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace(24.h),
            ElevatedButton.icon(
              onPressed: () {
                final cubit = context.read<ExamCreationCubit>();
                if (cubit.currentExamId != null) {
                  cubit.loadExamQuestions(cubit.currentExamId!);
                }
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainBlue,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    // Requires AlwaysScrollableScrollPhysics to allow refreshing on empty state
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.mainBlue.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.quiz_outlined,
                      color: AppColors.mainBlue,
                      size: 48.sp,
                    ),
                  ),
                  verticalSpace(20.h),
                  Text(
                    'No Questions Yet',
                    style: AppTextStyles.white20.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  verticalSpace(8.h),
                  Text(
                    'Tap the + Add Question button to add your first question.',
                    style: AppTextStyles.white16w400.copyWith(
                      color: AppColors.white60,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsList(
    List<QuestionLocalDto> questions,
    BuildContext context,
  ) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.h,
      ).copyWith(bottom: 100.h),
      itemCount: questions.length,
      separatorBuilder: (context, index) => verticalSpace(12.h),
      itemBuilder: (context, index) {
        final q = questions[index];
        return QuestionCard(
          question: q,
          index: index,
          onTap: () => onAddQuestion(initialQuestion: q),
          onDelete: () {
            _showDeleteConfirmationDialog(context, q);
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    QuestionLocalDto question,
  ) async {
    final cubit = context.read<ExamCreationCubit>();

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
                        isSuccess ? 'Deleted!' : 'Delete Question?',
                        style: AppTextStyles.white16w400.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        isSuccess
                            ? 'The question has been successfully deleted.'
                            : 'Are you sure you want to delete this question? This action cannot be undone.',
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
                                      final result = await cubit.deleteQuestion(
                                        question.id!,
                                      );

                                      result.when(
                                        success: (_) async {
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
                                        },
                                        failure: (error) {
                                          setState(() => isDeleting = false);
                                          if (context.mounted) {
                                            toastification.show(
                                              context: context,
                                              title: Text(
                                                error.apiErrorModel.message ??
                                                    'Failed to delete question',
                                              ),
                                              style: ToastificationStyle
                                                  .fillColored,
                                              type: ToastificationType.error,
                                              autoCloseDuration: const Duration(
                                                seconds: 3,
                                              ),
                                            );
                                          }
                                        },
                                      );
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
