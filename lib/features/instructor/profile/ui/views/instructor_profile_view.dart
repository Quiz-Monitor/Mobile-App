import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';

class InstructorProfileView extends StatelessWidget {
  const InstructorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Instructor Profile', style: AppTextStyles.white20),
    );
  }
}
