import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/edit_exam_info_tab.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_form_bottom_sheet.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/questions_tab.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/creation_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

/// Full-screen management view for draft exams.
/// Tab 1 – Questions: list + add/edit questions.
/// Tab 2 – Exam Info: edit exam metadata (title, time, proctoring).
class DraftExamManagementView extends StatefulWidget {
  final ExamModel exam;
  const DraftExamManagementView({super.key, required this.exam});

  @override
  State<DraftExamManagementView> createState() =>
      _DraftExamManagementViewState();
}

class _DraftExamManagementViewState extends State<DraftExamManagementView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load questions from API
    context.read<ExamCreationCubit>().loadExamQuestions(widget.exam.examId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _handlePublish() {
    context.read<ExamCreationCubit>().publishExam();
  }

  void _showToast(String message, ToastificationType type) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.fillColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamCreationCubit, ExamCreationState>(
      listener: (context, state) {
        if (state is QuestionAddedSuccess) {
          _showToast(
            'Question added successfully!',
            ToastificationType.success,
          );
          Navigator.of(context).pop(); // Close bottom sheet
        } else if (state is QuestionUpdatedSuccess) {
          _showToast(
            'Question updated successfully!',
            ToastificationType.success,
          );
          Navigator.of(context).pop(); // Close bottom sheet
        } else if (state is ExamUpdatedSuccess) {
          _showToast(
            'Exam info updated successfully!',
            ToastificationType.success,
          );
        } else if (state is ExamPublishedSuccess) {
          _showToast(
            'Exam published successfully! 🎉',
            ToastificationType.success,
          );
          Navigator.of(context).pop(true);
        } else if (state is QuestionDeletedSuccess) {
          _showToast(
            'Question deleted successfully!',
            ToastificationType.success,
          );
        } else if (state is ExamCreationError) {
          _showToast(state.message, ToastificationType.error);
        }
      },
      child: BlocBuilder<ExamCreationCubit, ExamCreationState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.primaryBlack,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.exam.title, style: AppTextStyles.white20),
                      Text(
                        'Draft',
                        style: AppTextStyles.white12w400alpha40.copyWith(
                          color: const Color(0xFFFACC15),
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    TextButton.icon(
                      onPressed: _handlePublish,
                      icon: const Icon(Icons.publish, size: 18),
                      label: const Text('Publish'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.mainGreen,
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.mainBlue,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.white40,
                    tabs: const [
                      Tab(icon: Icon(Icons.quiz_outlined), text: 'Questions'),
                      Tab(icon: Icon(Icons.edit_outlined), text: 'Exam Info'),
                    ],
                  ),
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    QuestionsTab(
                      examId: widget.exam.examId,
                      onAddQuestion: _showQuestionForm,
                    ),
                    EditExamInfoTab(exam: widget.exam, showToast: _showToast),
                  ],
                ),
                floatingActionButton: AnimatedBuilder(
                  animation: _tabController,
                  builder: (context, _) {
                    if (_tabController.index != 0) {
                      return const SizedBox.shrink();
                    }
                    return FloatingActionButton.extended(
                      onPressed: () => _showQuestionForm(),
                      backgroundColor: AppColors.mainBlue,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: Text(
                        'Add Question',
                        style: AppTextStyles.white16w400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ),
              CreationLoadingOverlay(
                isLoading: state is ExamPublishing,
                message: 'Publishing exam...',
              ),
            ],
          );
        },
      ),
    );
  }
}
