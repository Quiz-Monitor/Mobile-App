import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_form_bottom_sheet.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageQuestionsView extends StatefulWidget {
  final ExamModel exam;
  const ManageQuestionsView({super.key, required this.exam});

  @override
  State<ManageQuestionsView> createState() => _ManageQuestionsViewState();
}

class _ManageQuestionsViewState extends State<ManageQuestionsView> {
  @override
  void initState() {
    super.initState();
    // Pre-set the exam id so cubit can operate
    context.read<ExamCreationCubit>().currentExamId = widget.exam.examId;
  }

  void _showQuestionForm({QuestionLocalDto? initialQuestion}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<ExamCreationCubit>(),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
            ),
            child: QuestionFormBottomSheet(initialQuestion: initialQuestion),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamCreationCubit, ExamCreationState>(
      listener: (context, state) {
        if (state is QuestionAddedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question successfully added!')),
          );
          Navigator.of(context).pop(); // Close bottom sheet
        } else if (state is QuestionUpdatedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question successfully updated!')),
          );
          Navigator.of(context).pop(); // Close bottom sheet
        } else if (state is ExamCreationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryBlack,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(widget.exam.title, style: AppTextStyles.white20),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showQuestionForm(),
          backgroundColor: AppColors.mainBlue,
          label: Text(
            '+ Add Question',
            style: AppTextStyles.white16w400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<ExamCreationCubit, ExamCreationState>(
            builder: (context, state) {
              final questions = context
                  .read<ExamCreationCubit>()
                  .addedQuestions;

              if (questions.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          color: AppColors.white60,
                          size: 48.sp,
                        ),
                        verticalSpace(16.h),
                        Text(
                          'No questions added in this session yet.',
                          style: AppTextStyles.white16w400.copyWith(
                            color: AppColors.white60,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ).copyWith(bottom: 100.h),
                itemCount: questions.length,
                separatorBuilder: (context, index) => verticalSpace(12.h),
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return InkWell(
                    onTap: () => _showQuestionForm(initialQuestion: q),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.white5,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.mainBlue.withAlpha(40),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  _formatType(q.type),
                                  style: AppTextStyles.white12w400alpha40
                                      .copyWith(color: AppColors.mainBlue),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${q.points} pts',
                                style: AppTextStyles.white12w400alpha40
                                    .copyWith(color: AppColors.mainGreen),
                              ),
                            ],
                          ),
                          verticalSpace(12.h),
                          Text(q.text, style: AppTextStyles.white16w400),
                          verticalSpace(8.h),
                          Text(
                            '${q.choices.length} choices',
                            style: AppTextStyles.white12w400alpha40.copyWith(
                              color: AppColors.white40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatType(String type) {
    return switch (type) {
      'mcq_single' => 'MCQ (Single)',
      'mcq_multiple' => 'MCQ (Multi)',
      'true_false' => 'True/False',
      'short_answer' => 'Short Answer',
      'essay' => 'Essay',
      _ => type,
    };
  }
}
