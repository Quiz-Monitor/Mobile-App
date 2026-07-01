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
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class EditExamInfoTab extends StatefulWidget {
  final ExamModel exam;
  final void Function(String message, ToastificationType type) showToast;

  const EditExamInfoTab({
    super.key,
    required this.exam,
    required this.showToast,
  });

  @override
  State<EditExamInfoTab> createState() => _EditExamInfoTabState();
}

class _EditExamInfoTabState extends State<EditExamInfoTab>
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
