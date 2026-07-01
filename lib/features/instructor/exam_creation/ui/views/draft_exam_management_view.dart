import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/creation_loading_overlay.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/proctoring_switch_tile.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_form_bottom_sheet.dart';
import 'package:examify/features/instructor/exams/ui/utils/exam_actions_handler.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
    ExamActionsHandler.publishExam(
      context,
      widget.exam,
      () => Navigator.of(context).pop(true),
    );
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
        } else if (state is ExamCreationError) {
          _showToast(state.message, ToastificationType.error);
        }
      },
      child: Scaffold(
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
              style: TextButton.styleFrom(foregroundColor: AppColors.mainGreen),
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
            _QuestionsTab(onAddQuestion: _showQuestionForm),
            _EditExamInfoTab(exam: widget.exam, showToast: _showToast),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController,
          builder: (context, _) {
            if (_tabController.index != 0) return const SizedBox.shrink();
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
    );
  }
}

// ──────────────────────────────────────────────
// Tab 1 – Questions
// ──────────────────────────────────────────────
class _QuestionsTab extends StatelessWidget {
  final void Function({QuestionLocalDto? initialQuestion}) onAddQuestion;

  const _QuestionsTab({required this.onAddQuestion});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExamCreationCubit, ExamCreationState>(
      builder: (context, state) {
        if (state is QuestionsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ExamCreationError &&
            context.read<ExamCreationCubit>().addedQuestions.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: AppColors.white40,
                  size: 48.sp,
                ),
                verticalSpace(12.h),
                Text(
                  state.message,
                  style: AppTextStyles.white16w400.copyWith(
                    color: AppColors.white60,
                  ),
                  textAlign: TextAlign.center,
                ),
                verticalSpace(16.h),
                TextButton(
                  onPressed: () {
                    final cubit = context.read<ExamCreationCubit>();
                    if (cubit.currentExamId != null) {
                      cubit.loadExamQuestions(cubit.currentExamId!);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final questions = context.read<ExamCreationCubit>().addedQuestions;

        if (questions.isEmpty) {
          return Center(
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
            return _QuestionCard(
              question: q,
              index: index,
              onTap: () => onAddQuestion(initialQuestion: q),
            );
          },
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final QuestionLocalDto question;
  final int index;
  final VoidCallback onTap;

  const _QuestionCard({
    required this.question,
    required this.index,
    required this.onTap,
  });

  static const _typeColors = {
    'mcq_single': Color(0xFF3B82F6),
    'mcq_multiple': Color(0xFF8B5CF6),
    'true_false': Color(0xFF10B981),
    'short_answer': Color(0xFFF59E0B),
    'essay': Color(0xFFEF4444),
  };

  String _formatType(String type) => switch (type) {
    'mcq_single' => 'MCQ Single',
    'mcq_multiple' => 'MCQ Multi',
    'true_false' => 'True / False',
    'short_answer' => 'Short Answer',
    'essay' => 'Essay',
    _ => type,
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[question.type] ?? AppColors.mainBlue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _formatType(question.type),
                    style: TextStyle(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${question.points} pts',
                  style: AppTextStyles.white12w400alpha40.copyWith(
                    color: AppColors.mainGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.white40,
                  size: 18.sp,
                ),
              ],
            ),
            verticalSpace(12.h),
            Text(
              question.text,
              style: AppTextStyles.white16w400,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (question.choices.isNotEmpty) ...[
              verticalSpace(8.h),
              Text(
                '${question.choices.length} choices',
                style: AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.white40,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Tab 2 – Edit Exam Info
// ──────────────────────────────────────────────
class _EditExamInfoTab extends StatefulWidget {
  final ExamModel exam;
  final void Function(String message, ToastificationType type) showToast;

  const _EditExamInfoTab({required this.exam, required this.showToast});

  @override
  State<_EditExamInfoTab> createState() => _EditExamInfoTabState();
}

class _EditExamInfoTabState extends State<_EditExamInfoTab>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _durationController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _maxEyeAwayController;

  DateTime? _startDate;
  DateTime? _endDate;

  late bool _cameraRequired;
  late bool _tabSwitchingDetection;
  late bool _eyeTrackingEnabled;
  late bool _multiplePersonDetection;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final exam = widget.exam;
    _titleController = TextEditingController(text: exam.title);
    _durationController = TextEditingController(
      text: exam.durationMinutes.toString(),
    );
    _descriptionController = TextEditingController(text: exam.description);

    _startDate = exam.startTime;
    _endDate = exam.endTime;
    _startDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(exam.startTime),
    );
    _endDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd HH:mm').format(exam.endTime),
    );

    _maxEyeAwayController = TextEditingController();

    // Default proctoring to reasonable defaults (API may not expose these on ExamModel)
    _cameraRequired = true;
    _tabSwitchingDetection = true;
    _eyeTrackingEnabled = true;
    _multiplePersonDetection = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _maxEyeAwayController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isStart) async {
    final initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initial),
      );

      if (pickedTime != null && mounted) {
        final finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          final formatted = DateFormat(
            'yyyy-MM-dd HH:mm',
          ).format(finalDateTime);
          if (isStart) {
            _startDate = finalDateTime;
            _startDateController.text = formatted;
          } else {
            _endDate = finalDateTime;
            _endDateController.text = formatted;
          }
        });
      }
    }
  }

  void _onSaveInfo() {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      widget.showToast(
        'Please select both start and end dates.',
        ToastificationType.warning,
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      widget.showToast(
        'End date must be after start date.',
        ToastificationType.warning,
      );
      return;
    }

    final body = CreateExamRequestBody(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      durationMinutes: int.parse(_durationController.text.trim()),
      startTime: _startDate!.toUtc().toIso8601String(),
      endTime: _endDate!.toUtc().toIso8601String(),
      cameraRequired: _cameraRequired,
      tabSwitchingDetection: _tabSwitchingDetection,
      eyeTrackingEnabled: _eyeTrackingEnabled,
      multiplePersonDetection: _multiplePersonDetection,
      maxTabSwitches: 1,
      maxEyeAwaySeconds: int.tryParse(_maxEyeAwayController.text.trim()) ?? 0,
    );

    context.read<ExamCreationCubit>().updateExamInfo(widget.exam.examId, body);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ExamCreationCubit, ExamCreationState>(
      builder: (context, state) {
        final isLoading = state is ExamUpdateLoading;
        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ).copyWith(bottom: 40.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel(Icons.description_outlined, 'Exam Details'),
                    verticalSpace(12.h),
                    _card(
                      children: [
                        CustomTextfield(
                          controller: _titleController,
                          hintText: 'Exam Title',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        verticalSpace(14.h),
                        CustomTextfield(
                          controller: _durationController,
                          hintText: 'Duration (minutes)',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (v) =>
                              (v == null ||
                                  v.trim().isEmpty ||
                                  int.tryParse(v) == null)
                              ? 'Enter a valid number'
                              : null,
                        ),
                        verticalSpace(14.h),
                        CustomTextfield(
                          controller: _descriptionController,
                          hintText: 'Description',
                          maxLines: 3,
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        verticalSpace(14.h),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextfield(
                                controller: _startDateController,
                                hintText: 'Start Time',
                                readOnly: true,
                                onTap: () => _selectDateTime(true),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: CustomTextfield(
                                controller: _endDateController,
                                hintText: 'End Time',
                                readOnly: true,
                                onTap: () => _selectDateTime(false),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpace(20.h),
                    _sectionLabel(Icons.shield_outlined, 'Proctoring Settings'),
                    verticalSpace(12.h),
                    _card(
                      children: [
                        ProctoringSwitchTile(
                          icon: Icons.visibility_outlined,
                          title: 'Camera Required',
                          subtitle: 'Students must enable camera',
                          value: _cameraRequired,
                          onChanged: (val) =>
                              setState(() => _cameraRequired = val),
                        ),
                        ProctoringSwitchTile(
                          icon: Icons.desktop_windows_outlined,
                          title: 'Tab Switching Detection',
                          subtitle: 'Detect when student leaves exam tab',
                          value: _tabSwitchingDetection,
                          onChanged: (val) =>
                              setState(() => _tabSwitchingDetection = val),
                        ),
                        ProctoringSwitchTile(
                          icon: Icons.remove_red_eye_outlined,
                          title: 'Eye Tracking',
                          subtitle: 'Track student eye movement',
                          value: _eyeTrackingEnabled,
                          onChanged: (val) =>
                              setState(() => _eyeTrackingEnabled = val),
                        ),
                        if (_eyeTrackingEnabled) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomTextfield(
                              controller: _maxEyeAwayController,
                              hintText: 'Max Eye Away Seconds',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          verticalSpace(8.h),
                        ],
                        ProctoringSwitchTile(
                          icon: Icons.people_outline,
                          title: 'Multiple Person Detection',
                          subtitle: 'Detect if more than one person is present',
                          value: _multiplePersonDetection,
                          onChanged: (val) =>
                              setState(() => _multiplePersonDetection = val),
                        ),
                      ],
                    ),
                    verticalSpace(28.h),
                    CustomButton(
                      buttonContent: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Save Changes',
                            style: AppTextStyles.white16w400.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      onPressed: isLoading ? null : _onSaveInfo,
                    ),
                  ],
                ),
              ),
            ),
            CreationLoadingOverlay(
              isLoading: isLoading,
              message: 'Saving changes...',
            ),
          ],
        );
      },
    );
  }

  Widget _sectionLabel(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.white60, size: 18.sp),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.white16w400.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.white60,
          ),
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white3,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10, width: 1.w),
      ),
      child: Column(children: children),
    );
  }
}
