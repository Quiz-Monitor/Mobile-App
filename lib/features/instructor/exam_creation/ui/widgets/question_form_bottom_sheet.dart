import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionFormBottomSheet extends StatefulWidget {
  final QuestionLocalDto? initialQuestion;
  const QuestionFormBottomSheet({super.key, this.initialQuestion});

  @override
  State<QuestionFormBottomSheet> createState() =>
      _QuestionFormBottomSheetState();
}

class _QuestionFormBottomSheetState extends State<QuestionFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _questionController;
  late final TextEditingController _pointsController;

  final List<TextEditingController> _choiceControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  int _correctChoiceIndex = 0;
  final Set<int> _multipleCorrectChoices = {};
  bool? _trueFalseCorrect;
  String _selectedType = 'mcq_single';

  final List<Map<String, String>> _questionTypes = [
    {'label': 'MCQ (Single Correct)', 'value': 'mcq_single'},
    {'label': 'MCQ (Multiple Correct)', 'value': 'mcq_multiple'},
    {'label': 'True or False', 'value': 'true_false'},
    {'label': 'Short Answer', 'value': 'short_answer'},
    {'label': 'Essay', 'value': 'essay'},
  ];

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(
      text: widget.initialQuestion?.text ?? '',
    );
    _pointsController = TextEditingController(
      text: widget.initialQuestion?.points.toString() ?? '',
    );

    if (widget.initialQuestion != null) {
      _selectedType = widget.initialQuestion!.type;

      // Handle legacy or undefined types to prevent Dropdown assertion error
      if (!_questionTypes.any((type) => type['value'] == _selectedType)) {
        if (_selectedType == 'open_ended') {
          _selectedType = 'essay';
        } else {
          _selectedType = 'mcq_single'; // fallback
        }
      }

      final choices = widget.initialQuestion!.choices;

      if (_selectedType == 'mcq_single' || _selectedType == 'mcq_multiple') {
        for (int i = 0; i < choices.length && i < 4; i++) {
          _choiceControllers[i].text = choices[i].text;
          if (choices[i].isCorrect) {
            if (_selectedType == 'mcq_single') {
              _correctChoiceIndex = i;
            } else {
              _multipleCorrectChoices.add(i);
            }
          }
        }
      } else if (_selectedType == 'true_false') {
        if (choices.isNotEmpty) {
          _trueFalseCorrect =
              choices
                  .firstWhere(
                    (c) => c.isCorrect,
                    orElse: () => ChoiceDto(text: 'True', isCorrect: true),
                  )
                  .text
                  .toLowerCase() ==
              'true';
        }
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _pointsController.dispose();
    for (var c in _choiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onSaveQuestion() {
    if (_formKey.currentState!.validate()) {
      List<ChoiceDto> choices = [];

      if (_selectedType == 'mcq_single' || _selectedType == 'mcq_multiple') {
        if (_selectedType == 'mcq_multiple' &&
            _multipleCorrectChoices.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Select at least one correct choice.'),
            ),
          );
          return;
        }
        choices = List.generate(
          4,
          (i) => ChoiceDto(
            text: _choiceControllers[i].text.trim(),
            isCorrect: _selectedType == 'mcq_multiple'
                ? _multipleCorrectChoices.contains(i)
                : i == _correctChoiceIndex,
            orderNumber: i + 1,
          ),
        );
      } else if (_selectedType == 'true_false') {
        if (_trueFalseCorrect == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Select True or False.')),
          );
          return;
        }
        choices = [
          ChoiceDto(
            text: 'True',
            isCorrect: _trueFalseCorrect == true,
            orderNumber: 1,
          ),
          ChoiceDto(
            text: 'False',
            isCorrect: _trueFalseCorrect == false,
            orderNumber: 2,
          ),
        ];
      }

      final points = int.parse(_pointsController.text.trim());

      if (widget.initialQuestion != null &&
          widget.initialQuestion!.id != null) {
        context.read<ExamCreationCubit>().editQuestion(
          widget.initialQuestion!.id!,
          _questionController.text.trim(),
          _selectedType,
          points,
          choices,
        );
      } else {
        context.read<ExamCreationCubit>().addQuestion(
          _questionController.text.trim(),
          _selectedType,
          points,
          choices,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(top: BorderSide(color: AppColors.white10)),
      ),
      child: SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.initialQuestion != null
                          ? 'Edit Question'
                          : 'Add Question',
                      style: AppTextStyles.white20.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    verticalSpace(24.h),
                    Text(
                      'Question Layout',
                      style: AppTextStyles.white16w400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(16.h),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withAlpha((255 * .05).round()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      dropdownColor: AppColors.primaryBlack,
                      style: AppTextStyles.white16w400,
                      items: _questionTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type['value'],
                          child: Text(type['label']!),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedType = val;
                            _correctChoiceIndex = 0;
                            _multipleCorrectChoices.clear();
                            _trueFalseCorrect = null;
                          });
                        }
                      },
                    ),
                    verticalSpace(16.h),
                    CustomTextfield(
                      controller: _questionController,
                      hintText: 'Enter Question Text',
                      validator: (value) => value!.trim().isEmpty
                          ? 'Please enter question'
                          : null,
                    ),
                    verticalSpace(16.h),
                    CustomTextfield(
                      controller: _pointsController,
                      hintText: 'Points (e.g. 5)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) =>
                          (value!.trim().isEmpty || int.tryParse(value) == null)
                          ? 'Enter valid points'
                          : null,
                    ),
                    verticalSpace(32.h),
                    if (_selectedType == 'mcq_single' ||
                        _selectedType == 'mcq_multiple') ...[
                      Text(
                        'Choices',
                        style: AppTextStyles.white16w400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      verticalSpace(8.h),
                      ...List.generate(4, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Row(
                            children: [
                              if (_selectedType == 'mcq_single')
                                Radio<int>(
                                  value: index,
                                  groupValue: _correctChoiceIndex,
                                  activeColor: AppColors.mainGreen,
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() => _correctChoiceIndex = val);
                                    }
                                  },
                                )
                              else
                                Checkbox(
                                  value: _multipleCorrectChoices.contains(
                                    index,
                                  ),
                                  activeColor: AppColors.mainGreen,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _multipleCorrectChoices.add(index);
                                      } else {
                                        _multipleCorrectChoices.remove(index);
                                      }
                                    });
                                  },
                                ),
                              Expanded(
                                child: CustomTextfield(
                                  controller: _choiceControllers[index],
                                  hintText: 'Choice ${index + 1}',
                                  validator: (value) => value!.trim().isEmpty
                                      ? 'Cannot be empty'
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ] else if (_selectedType == 'true_false') ...[
                      Text(
                        'Select Correct Answer',
                        style: AppTextStyles.white16w400.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      verticalSpace(8.h),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text(
                                'True',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: true,
                              groupValue: _trueFalseCorrect,
                              activeColor: AppColors.mainGreen,
                              onChanged: (val) =>
                                  setState(() => _trueFalseCorrect = val),
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<bool>(
                              title: const Text(
                                'False',
                                style: TextStyle(color: Colors.white),
                              ),
                              value: false,
                              groupValue: _trueFalseCorrect,
                              activeColor: AppColors.mainGreen,
                              onChanged: (val) =>
                                  setState(() => _trueFalseCorrect = val),
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Center(
                        child: Text(
                          'Students will manually enter their answer during the exam.',
                          style: AppTextStyles.white16w400.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    verticalSpace(24.h),
                    BlocBuilder<ExamCreationCubit, ExamCreationState>(
                      builder: (context, state) {
                        if (state is QuestionAdding ||
                            state is QuestionUpdating) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }
                        return CustomButton(
                          buttonContent: Text(
                            widget.initialQuestion != null
                                ? 'Save Changes'
                                : 'Add Question',
                            style: AppTextStyles.white16w400.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: _onSaveQuestion,
                        );
                      },
                    ),
                    verticalSpace(40.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
