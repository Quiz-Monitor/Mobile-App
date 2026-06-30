import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/ui/utils/exam_actions_handler.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcomingExamOptionsBottomSheet extends StatelessWidget {
  const UpcomingExamOptionsBottomSheet({
    super.key,
    required this.exam,
    required this.onPublishSuccess,
  });

  final ExamModel exam;
  final VoidCallback onPublishSuccess;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Draft Exam Options',
              style: AppTextStyles.white20,
              textAlign: TextAlign.center,
            ),
            verticalSpace(24.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  Routes.manageQuestionsScreen,
                  arguments: exam,
                );
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('Manage Questions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainBlue.withAlpha(50),
                foregroundColor: AppColors.mainBlue,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            verticalSpace(16.h),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ExamActionsHandler.publishExam(context, exam, onPublishSuccess);
              },
              icon: const Icon(Icons.publish),
              label: const Text('Publish Exam'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainGreen.withAlpha(50),
                foregroundColor: AppColors.mainGreen,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
