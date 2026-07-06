import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class PreviewExamStep3Widget extends StatelessWidget {
  const PreviewExamStep3Widget({super.key});

  Widget _buildProctoringRow(String label, bool value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.white14w400alpha70.copyWith(
              color: AppColors.white40,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: value
                  ? AppColors.mainGreen.withAlpha(20)
                  : AppColors.white10.withAlpha(20),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: value
                    ? AppColors.mainGreen.withAlpha(40)
                    : AppColors.white10,
              ),
            ),
            child: Text(
              value ? 'ON' : 'OFF',
              style: AppTextStyles.white12w400alpha40.copyWith(
                color: value ? AppColors.mainGreen : AppColors.white40,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCreationCubit, ExamCreationState>(
      listener: (context, state) {
        if (state is ExamCreationError) {
          toastification.show(
            context: context,
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            title: Text(state.message),
            autoCloseDuration: const Duration(seconds: 3),
            alignment: Alignment.bottomCenter,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ExamCreationCubit>();
        final details = cubit.currentExamDetails;
        final questions = cubit.addedQuestions;

        final isLoading = state is ExamPublishing;

        if (details == null) {
          return const Center(
            child: Text(
              'No exam details found. Please go back.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final startDate = DateTime.tryParse(details.startTime)?.toLocal();
        final endDate = DateTime.tryParse(details.endTime)?.toLocal();
        final startFormatted = startDate != null
            ? DateFormat('MMM d, hh:mm a').format(startDate)
            : '';
        final endFormatted = endDate != null
            ? DateFormat('MMM d, hh:mm a').format(endDate)
            : '';

        final totalPoints = questions.fold(0, (sum, q) => sum + q.points);

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        verticalSpace(24.h),

                        // EXAM DETAILS Section
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white3,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: AppColors.white10,
                              width: 1.74.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    color: AppColors.mainBlue,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'EXAM DETAILS',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(
                                          color: AppColors.white40,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                              verticalSpace(16.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Title',
                                    style: AppTextStyles.white14w400alpha70
                                        .copyWith(color: AppColors.white40),
                                  ),
                                  Text(
                                    details.title,
                                    style: AppTextStyles.white14w400alpha70,
                                  ),
                                ],
                              ),
                              verticalSpace(8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Duration',
                                    style: AppTextStyles.white14w400alpha70
                                        .copyWith(color: AppColors.white40),
                                  ),
                                  Text(
                                    '${details.durationMinutes} min',
                                    style: AppTextStyles.white14w400alpha70,
                                  ),
                                ],
                              ),
                              verticalSpace(8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description',
                                    style: AppTextStyles.white14w400alpha70
                                        .copyWith(color: AppColors.white40),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: Text(
                                      details.description,
                                      style: AppTextStyles.white14w400alpha70,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(12.h),
                              Row(
                                children: [
                                  Text(
                                    'Start',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(color: AppColors.white40),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    startFormatted,
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(color: Colors.white),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'End',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(color: AppColors.white40),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    endFormatted,
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(20.h),

                        // PROCTORING Section
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white3,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: AppColors.white10,
                              width: 1.74.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.shield_outlined,
                                    color: AppColors.mainBlue,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'PROCTORING',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(
                                          color: AppColors.white40,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                ],
                              ),
                              verticalSpace(16.h),
                              _buildProctoringRow(
                                'Camera Required',
                                details.cameraRequired,
                              ),
                              _buildProctoringRow(
                                'Tab Switching Detection',
                                details.tabSwitchingDetection,
                              ),
                              _buildProctoringRow(
                                'Eye Tracking',
                                details.eyeTrackingEnabled,
                              ),
                              _buildProctoringRow(
                                'Multiple Person Detection',
                                details.multiplePersonDetection,
                              ),
                            ],
                          ),
                        ),
                        verticalSpace(20.h),

                        // QUESTIONS Section
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white3,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: AppColors.white10,
                              width: 1.74.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: AppColors.mainBlue,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'QUESTIONS',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(
                                          color: AppColors.white40,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.2,
                                        ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${questions.length} total - $totalPoints pts',
                                    style: AppTextStyles.white12w400alpha40
                                        .copyWith(color: AppColors.mainBlue),
                                  ),
                                ],
                              ),
                              verticalSpace(16.h),
                              ...questions.asMap().entries.map((entry) {
                                final index = entry.key;
                                final question = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == questions.length - 1
                                        ? 0
                                        : 12.h,
                                  ),
                                  child: IgnorePointer(
                                    child: QuestionCard(
                                      question: question,
                                      index: index,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),

                        verticalSpace(32.h),

                        CustomButton(
                          buttonContent: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Publish Exam',
                                style: AppTextStyles.white16w400.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  cubit.publishExam();
                                },
                        ),
                        verticalSpace(40.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
