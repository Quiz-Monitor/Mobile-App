import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/proctoring_switch_tile.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class CreateExamStep1Widget extends StatefulWidget {
  const CreateExamStep1Widget({super.key});

  @override
  State<CreateExamStep1Widget> createState() => _CreateExamStep1WidgetState();
}

class _CreateExamStep1WidgetState extends State<CreateExamStep1Widget> {
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
  final _maxEyeAwaySecondsController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
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
      maxTabSwitches: 1,
      maxEyeAwaySeconds:
          int.tryParse(_maxEyeAwaySecondsController.text.trim()) ?? 0,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // ── Exam Details Section ──
            const SectionHeader(
              icon: Icons.description_outlined,
              title: 'Exam Details',
            ),
            verticalSpace(12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.white3,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.white10, width: 1.74.w),
              ),
              child: Column(
                children: [
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    maxLines: 4,
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
                          validator: (value) => value == null || value.isEmpty
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
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            verticalSpace(20.h),

            // ── Proctoring Settings Section ──
            const SectionHeader(
              icon: Icons.shield_outlined,
              title: 'Proctoring Settings',
            ),
            verticalSpace(12.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColors.white3,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.white10, width: 1.74.w),
              ),
              child: Column(
                children: [
                  ProctoringSwitchTile(
                    icon: Icons.visibility_outlined,
                    title: 'Camera Required',
                    subtitle: 'Students must enable camera',
                    value: _cameraRequired,
                    onChanged: (val) => setState(() => _cameraRequired = val),
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
                        controller: _maxEyeAwaySecondsController,
                        hintText: 'Max Eye Away Seconds',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    verticalSpace(16.h),
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
            ),

            verticalSpace(32.h),

            // ── Action Buttons ──
            CustomButton(
              buttonContent: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Save & Add Questions',
                    style: AppTextStyles.white16w400.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                final body = _buildRequestBody();
                if (body == null) return;
                context.read<ExamCreationCubit>().createExam(body);
              },
            ),
            verticalSpace(40.h),
          ],
        ),
      ),
    );
  }
}
