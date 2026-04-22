import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_cubit.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class JoinExamBottomSheet extends StatefulWidget {
  const JoinExamBottomSheet({
    super.key,
    required this.examCodeController,
    required this.onJoinSuccess,
  });

  final TextEditingController examCodeController;
  final VoidCallback onJoinSuccess;

  @override
  State<JoinExamBottomSheet> createState() => _JoinExamBottomSheetState();
}

class _JoinExamBottomSheetState extends State<JoinExamBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinExamCubit, JoinExamState>(
      listenWhen: (previous, current) =>
          current is JoinExamSuccess || current is JoinExamFailure,
      listener: (context, state) {
        if (state is JoinExamFailure) {
          toastification.show(
            context: context,
            autoCloseDuration: const Duration(seconds: 5),
            style: ToastificationStyle.fillColored,
            type: ToastificationType.error,
            description: RichText(text: TextSpan(text: state.message)),
          );
          return;
        }

        if (state is JoinExamSuccess) {
          final successMessage =
              state.response.message ?? 'Exam joined successfully.';
          toastification.show(
            context: context,
            autoCloseDuration: const Duration(seconds: 5),
            style: ToastificationStyle.fillColored,
            type: ToastificationType.success,
            description: RichText(text: TextSpan(text: successMessage)),
          );
          Navigator.of(context).pop();
          widget.onJoinSuccess();
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.3177,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 13,
            right: 20,
            left: 20,
            bottom: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.white40,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              Form(
                key: _formKey,
                child: CustomTextfield(
                  hintText: 'Enter exam code',
                  controller: widget.examCodeController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Exam code is required';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20.h),
              BlocBuilder<JoinExamCubit, JoinExamState>(
                builder: (context, state) {
                  final isLoading = state is JoinExamLoading;
                  return CustomButton(
                    buttonContent: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Join Exam',
                            style: AppTextStyles.white16w400.copyWith(),
                          ),
                    onPressed: isLoading
                        ? null
                        : () {
                            final isValid =
                                _formKey.currentState?.validate() ?? false;
                            if (!isValid) {
                              return;
                            }

                            context.read<JoinExamCubit>().joinExam(
                              widget.examCodeController.text,
                            );
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
