import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class InstructorExamsView extends StatelessWidget {
  const InstructorExamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Instructor Exams', style: AppTextStyles.white20),
    );
  }
}
