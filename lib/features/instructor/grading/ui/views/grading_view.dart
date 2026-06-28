import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/features/instructor/grading/data/models/written_answer_model.dart';
import 'package:examify/features/instructor/grading/logic/cubit/grading_cubit.dart';
import 'package:examify/features/instructor/grading/logic/cubit/grading_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradingView extends StatelessWidget {
  final int studentId;
  final int examId;

  const GradingView({super.key, required this.studentId, required this.examId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Grade Written Answers', style: AppTextStyles.white20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<GradingCubit, GradingState>(
        listener: (context, state) {
          if (state is GradingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is GradingAnswerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Grade submitted successfully!')),
            );
          }
        },
        builder: (context, state) {
          if (state is GradingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final answers = _getAnswersFromState(context);
          if (answers == null && state is! GradingLoaded) {
            return const SizedBox();
          }

          if (answers != null && answers.isEmpty) {
            return Center(
              child: Text(
                'No written answers to grade.',
                style: AppTextStyles.white16w400
                    .copyWith(fontWeight: FontWeight.w600)
                    .copyWith(color: AppColors.white60),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            itemCount: answers?.length ?? 0,
            separatorBuilder: (_, __) => verticalSpace(16.h),
            itemBuilder: (context, index) {
              final answer = answers![index];
              return _GradingCardItem(answer: answer, state: state);
            },
          );
        },
      ),
    );
  }

  List<WrittenAnswerModel>? _getAnswersFromState(BuildContext context) {
    final state = context.read<GradingCubit>().state;
    if (state is GradingLoaded) return state.answers;
    // For other states (loading answer), we could retain the current list from the UI if needed
    // But our cubit design restores GradingLoaded swiftly after success/error.
    return null; // Will just rely on Builder if state isn't Loaded
  }
}

class _GradingCardItem extends StatefulWidget {
  final WrittenAnswerModel answer;
  final GradingState state;

  const _GradingCardItem({required this.answer, required this.state});

  @override
  State<_GradingCardItem> createState() => _GradingCardItemState();
}

class _GradingCardItemState extends State<_GradingCardItem> {
  final _gradeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _gradeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting =
        widget.state is GradingAnswerSubmitting &&
        (widget.state as GradingAnswerSubmitting).answerId ==
            widget.answer.answerId;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white10),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q: ${widget.answer.questionText}',
              style: AppTextStyles.white16w400
                  .copyWith(fontWeight: FontWeight.w600)
                  .copyWith(color: AppColors.mainBlue),
            ),
            verticalSpace(12.h),
            Text(
              'Student\'s Answer:',
              style: AppTextStyles.white12w400alpha40.copyWith(
                color: AppColors.white60,
              ),
            ),
            verticalSpace(8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                widget.answer.studentAnswerText.isEmpty
                    ? 'No Answer Provided'
                    : widget.answer.studentAnswerText,
                style: AppTextStyles.white16w400,
              ),
            ),
            verticalSpace(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextfield(
                    controller: _gradeController,
                    hintText: 'Grade (e.g. 5.0)',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter grade';
                      if (double.tryParse(val) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ),
                horizontalSpace(12.w),
                Expanded(
                  flex: 2,
                  child: isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          buttonContent: Text(
                            'Submit',
                            style: AppTextStyles.white16w400.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final grade = double.parse(_gradeController.text);
                              context.read<GradingCubit>().submitGrade(
                                widget.answer.answerId,
                                grade,
                              );
                            }
                          },
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
