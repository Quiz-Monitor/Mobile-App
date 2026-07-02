import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/add_question_step2_widget.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/create_exam_step1_widget.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/preview_exam_step3_widget.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/creation_loading_overlay.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/form_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  int _currentStep = 1;

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Create Exam', style: AppTextStyles.white20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<ExamCreationCubit, ExamCreationState>(
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
          } else if (state is ExamCreatedSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              title: const Text('Exam created! Now add questions.'),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
            );
            _goToStep(2);
          } else if (state is ExamPublishedSuccess) {
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.fillColored,
              title: const Text('Exam published successfully! 🎉'),
              autoCloseDuration: const Duration(seconds: 3),
              alignment: Alignment.bottomCenter,
            );
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        builder: (context, state) {
          final isLoading =
              state is ExamCreationLoading || state is ExamPublishing;

          Widget currentWidget;
          if (_currentStep == 1) {
            currentWidget = const CreateExamStep1Widget();
          } else if (_currentStep == 2) {
            currentWidget = AddQuestionStep2Widget(
              onContinue: () => _goToStep(3),
            );
          } else {
            currentWidget = const PreviewExamStep3Widget();
          }

          return Stack(
            children: [
              Column(
                children: [
                  // Fixed step indicator at the top
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: FormStepper(currentStep: _currentStep),
                  ),
                  // Scrollable content below
                  Expanded(child: currentWidget),
                ],
              ),
              CreationLoadingOverlay(
                isLoading: isLoading,
                message: state is ExamPublishing
                    ? 'Publishing exam...'
                    : 'Creating exam...',
              ),
            ],
          );
        },
      ),
    );
  }
}
