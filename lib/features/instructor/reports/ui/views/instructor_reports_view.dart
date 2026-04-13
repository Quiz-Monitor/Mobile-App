import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class InstructorReportsView extends StatelessWidget {
  const InstructorReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      appBar: AppBar(
        title: Text('Reports', style: AppTextStyles.white20),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_rounded,
              size: 64,
              color: AppColors.blueBorder,
            ),
            const SizedBox(height: 16),
            Text('Performance Reports', style: AppTextStyles.white16w400),
            const SizedBox(height: 8),
            Text('Coming soon...', style: AppTextStyles.white12w400alpha40),
          ],
        ),
      ),
    );
  }
}
