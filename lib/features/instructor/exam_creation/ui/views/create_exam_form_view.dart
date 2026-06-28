import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class CreateExamFormView extends StatefulWidget {
  const CreateExamFormView({super.key});

  @override
  State<CreateExamFormView> createState() => _CreateExamFormViewState();
}

class _CreateExamFormViewState extends State<CreateExamFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _cameraRequired = true;
  bool _tabSwitchingDetection = true;
  bool _eyeTrackingEnabled = true;
  bool _multiplePersonDetection = true;
  final _maxTabSwitchesController = TextEditingController();
  final _maxEyeAwaySecondsController = TextEditingController();

  /// Tracks what the user wants after creating:
  /// true  → navigate to Add Questions
  /// false → publish immediately
  bool _goToAddQuestions = true;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _maxTabSwitchesController.dispose();
    _maxEyeAwaySecondsController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
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

  CreateExamRequestBody? _buildRequestBody() {
    if (!_formKey.currentState!.validate()) return null;

    if (_startDate == null || _endDate == null) {
      _showToast(
        'Please select both start and end dates.',
        ToastificationType.warning,
      );
      return null;
    }

    if (_endDate!.isBefore(_startDate!)) {
      _showToast(
        'End date must be after start date.',
        ToastificationType.warning,
      );
      return null;
    }

    if (_startDate!.isBefore(DateTime.now())) {
      _showToast(
        'Start date must be in the future.',
        ToastificationType.warning,
      );
      return null;
    }

    return CreateExamRequestBody(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      durationMinutes: int.parse(_durationController.text.trim()),
      startTime: _startDate!.toUtc().toIso8601String(),
      endTime: _endDate!.toUtc().toIso8601String(),
      cameraRequired: _cameraRequired,
      tabSwitchingDetection: _tabSwitchingDetection,
      eyeTrackingEnabled: _eyeTrackingEnabled,
      multiplePersonDetection: _multiplePersonDetection,
      maxTabSwitches: int.tryParse(_maxTabSwitchesController.text.trim()) ?? 0,
      maxEyeAwaySeconds:
          int.tryParse(_maxEyeAwaySecondsController.text.trim()) ?? 0,
    );
  }

  void _onSaveAndAddQuestions() {
    final body = _buildRequestBody();
    if (body == null) return;
    _goToAddQuestions = true;
    context.read<ExamCreationCubit>().createExam(body);
  }

  void _onSaveAndPublish() {
    final body = _buildRequestBody();
    if (body == null) return;
    _goToAddQuestions = false;
    context.read<ExamCreationCubit>().createExam(body);
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
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Create Exam', style: AppTextStyles.white20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<ExamCreationCubit, ExamCreationState>(
        listener: (context, state) {
          if (state is ExamCreationError) {
            _showToast(state.message, ToastificationType.error);
          } else if (state is ExamCreatedSuccess) {
            if (_goToAddQuestions) {
              _showToast(
                'Exam created! Now add questions.',
                ToastificationType.success,
              );
              Navigator.pushReplacementNamed(
                context,
                Routes.addQuestionScreen,
                arguments: context.read<ExamCreationCubit>(),
              );
            } else {
              // User chose "Save & Publish" → publish right away
              context.read<ExamCreationCubit>().publishExam();
            }
          } else if (state is ExamPublishedSuccess) {
            _showToast(
              'Exam published successfully! 🎉',
              ToastificationType.success,
            );
            Navigator.pop(context, true); // Return true to refresh lists
          }
        },
        builder: (context, state) {
          final isLoading =
              state is ExamCreationLoading || state is ExamPublishing;

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // ── Exam Details Section ──
                      _buildSectionHeader(
                        icon: Icons.description_outlined,
                        title: 'Exam Details',
                      ),
                      verticalSpace(20.h),
                      CustomTextfield(
                        controller: _titleController,
                        hintText: 'Enter Exam Title',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter exam title';
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16.h),
                      CustomTextfield(
                        controller: _durationController,
                        hintText: 'Duration in Minutes (e.g., 60)',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter exam duration';
                          }
                          if (int.tryParse(value.trim()) == null) {
                            return 'Duration must be a valid number';
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16.h),
                      CustomTextfield(
                        controller: _descriptionController,
                        hintText: 'Enter Exam Description',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      verticalSpace(16.h),

                      // ── Date/Time Row ──
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextfield(
                              controller: _startDateController,
                              hintText: 'Start Time',
                              readOnly: true,
                              onTap: () => _selectDateTime(context, true),
                              validator: (value) =>
                                  value == null || value.isEmpty
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
                              onTap: () => _selectDateTime(context, false),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),

                      verticalSpace(28.h),

                      // ── Proctoring Settings Section ──
                      _buildSectionHeader(
                        icon: Icons.security_outlined,
                        title: 'Proctoring Settings',
                      ),
                      verticalSpace(16.h),
                      _buildProctoringSwitch(
                        title: 'Camera Required',
                        subtitle: 'Students must enable camera',
                        value: _cameraRequired,
                        onChanged: (val) =>
                            setState(() => _cameraRequired = val),
                      ),
                      _buildProctoringSwitch(
                        title: 'Tab Switching Detection',
                        subtitle: 'Detect when student leaves exam tab',
                        value: _tabSwitchingDetection,
                        onChanged: (val) =>
                            setState(() => _tabSwitchingDetection = val),
                      ),
                      if (_tabSwitchingDetection) ...[
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: CustomTextfield(
                            controller: _maxTabSwitchesController,
                            hintText: 'Max Tab Switches Allowed',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        verticalSpace(8.h),
                      ],
                      _buildProctoringSwitch(
                        title: 'Eye Tracking',
                        subtitle: 'Track student eye movement',
                        value: _eyeTrackingEnabled,
                        onChanged: (val) =>
                            setState(() => _eyeTrackingEnabled = val),
                      ),
                      if (_eyeTrackingEnabled) ...[
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: CustomTextfield(
                            controller: _maxEyeAwaySecondsController,
                            hintText: 'Max Eye Away Seconds',
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                        verticalSpace(8.h),
                      ],
                      _buildProctoringSwitch(
                        title: 'Multiple Person Detection',
                        subtitle: 'Detect if more than one person is present',
                        value: _multiplePersonDetection,
                        onChanged: (val) =>
                            setState(() => _multiplePersonDetection = val),
                      ),

                      verticalSpace(32.h),

                      // ── Action Buttons ──
                      CustomButton(
                        buttonContent: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Save & Add Questions',
                              style: AppTextStyles.white16w400.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onPressed: isLoading ? null : _onSaveAndAddQuestions,
                      ),
                      verticalSpace(14.h),
                      _buildPublishButton(isLoading),
                      verticalSpace(40.h),
                    ],
                  ),
                ),
              ),

              // ── Full-screen loading overlay ──
              if (isLoading)
                Container(
                  color: Colors.black.withAlpha(150),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        verticalSpace(16.h),
                        Text(
                          state is ExamPublishing
                              ? 'Publishing exam...'
                              : 'Creating exam...',
                          style: AppTextStyles.white16w400,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helper widgets
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.mainBlue.withAlpha(25),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.mainBlue, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: AppTextStyles.white16w400.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildProctoringSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.white10),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.white40, fontSize: 12.sp),
        ),
        value: value,
        activeColor: AppColors.mainGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPublishButton(bool isLoading) {
    return InkWell(
      onTap: isLoading ? null : _onSaveAndPublish,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.mainGreen, width: 1.5),
          color: AppColors.mainGreen.withAlpha(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.publish_outlined,
              color: AppColors.mainGreen,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'Save & Publish Now',
              style: AppTextStyles.white16w400.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.mainGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
