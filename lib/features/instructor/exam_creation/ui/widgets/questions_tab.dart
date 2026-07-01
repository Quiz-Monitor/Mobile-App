import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/creation_loading_overlay.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            CreationLoadingOverlay(
              isLoading: state is QuestionDeleting,
              message: 'Deleting question...',
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

  void _showDeleteConfirmationDialog(
    BuildContext context,
    QuestionLocalDto question,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.primaryBlack,
          title: Text('Delete Question', style: AppTextStyles.white20),
          content: Text(
            'Are you sure you want to delete this question?',
            style: AppTextStyles.white16w400,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: AppTextStyles.white16w400),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ExamCreationCubit>().deleteQuestion(question.id!);
              },
              child: Text(
                'Delete',
                style: AppTextStyles.white16w400.copyWith(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
