import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/history/ui/widgets/custom_evaluation_card.dart';
import 'package:examify/features/history/ui/widgets/custom_exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsHistory extends StatelessWidget {
  const ExamsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exams History', style: AppTextStyles.white20),

            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomEvaluationCard(title: '12', subTitle: 'Total'),
                CustomEvaluationCard(title: '10', subTitle: 'Passed'),
                CustomEvaluationCard(title: '82%', subTitle: 'Avg Score'),
              ],
            ),
            SizedBox(height: 28.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: CustomExamCard(isPending: true),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
