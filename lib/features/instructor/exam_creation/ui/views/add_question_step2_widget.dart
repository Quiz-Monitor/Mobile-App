import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/form_stepper.dart';
import 'package:examify/features/instructor/exam_creation/ui/widgets/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddQuestionStep2Widget extends StatefulWidget {
  final VoidCallback onContinue;

  const AddQuestionStep2Widget({super.key, required this.onContinue});

  @override
  State<AddQuestionStep2Widget> createState() => _AddQuestionStep2WidgetState();
}

class _AddQuestionStep2WidgetState extends State<AddQuestionStep2Widget> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _pointsController = TextEditingController();

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
  void dispose() {
    _questionController.dispose();
    _pointsController.dispose();
    for (var c in _choiceControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _resetForm() {
    _questionController.clear();
    _pointsController.clear();
    for (var c in _choiceControllers) {
      c.clear();
    }
    setState(() {
      _correctChoiceIndex = 0;
      _multipleCorrectChoices.clear();
      _trueFalseCorrect = null;
    });
  }

  void _onAddQuestion() {
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
          ChoiceDto(text: 'True', isCorrect: _trueFalseCorrect == true),
          ChoiceDto(text: 'False', isCorrect: _trueFalseCorrect == false),
        ];
      }

      final points = int.parse(_pointsController.text.trim());
      context.read<ExamCreationCubit>().addQuestion(
        _questionController.text.trim(),
        _selectedType,
        points,
        choices,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCreationCubit, ExamCreationState>(
      listener: (context, state) {
        if (state is ExamCreationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is QuestionAddedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Question correctly added!')),
          );
          _resetForm();
        }
      },
      builder: (context, state) {
        final cubit = context.read<ExamCreationCubit>();
        final questions = cubit.addedQuestions;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FormStepper(currentStep: 2),
                verticalSpace(24.h),
                if (questions.isNotEmpty) ...[
                  Text(
                    '${questions.length} QUESTION${questions.length > 1 ? 'S' : ''} ADDED',
                    style: AppTextStyles.white12w400alpha40.copyWith(
                      color: AppColors.white40,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  verticalSpace(12.h),
                  ...questions.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final QuestionLocalDto question = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: QuestionCard(
                        question: question,
                        index: index,
                        onTap: () {
                          // optional: prefill edit form
                        },
                        onDelete: () {
                          if (question.id != null) {
                            cubit.deleteQuestion(question.id!);
                          }
                        },
                      ),
                    );
                  }),
                  verticalSpace(24.h),
                ],
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.white3,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.white10, width: 1.74.w),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Add Question',
                          style: AppTextStyles.white16w400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        verticalSpace(16.h),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedType,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.primaryBlack,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(color: AppColors.white10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14.r),
                              borderSide: BorderSide(color: AppColors.white10),
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
                          validator: (value) =>
                              (value!.trim().isEmpty ||
                                  int.tryParse(value) == null)
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
                                          setState(
                                            () => _correctChoiceIndex = val,
                                          );
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
                        if (state is QuestionAdding || state is ExamPublishing)
                          const Center(child: CircularProgressIndicator())
                        else
                          CustomButton(
                            buttonContent: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add, color: Colors.white, size: 20.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  'Add Question',
                                  style: AppTextStyles.white16w400.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: _onAddQuestion,
                          ),
                      ],
                    ),
                  ),
                ),
                if (questions.isNotEmpty) ...[
                  verticalSpace(24.h),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      side: BorderSide(color: AppColors.white10, width: 1.74.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      backgroundColor: AppColors.white3,
                    ),
                    onPressed: widget.onContinue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Review',
                          style: AppTextStyles.white16w400.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ],
                verticalSpace(40.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
