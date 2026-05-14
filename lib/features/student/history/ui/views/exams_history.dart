import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/history/data/models/exams_history_model.dart';
import 'package:examify/features/student/history/ui/widgets/custom_evaluation_card.dart';
import 'package:examify/features/student/history/ui/widgets/custom_exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsHistory extends StatelessWidget {
  ExamsHistory({super.key});
  final List<CustomExamCard> exItems = [
    CustomExamCard(
      exHistoryModel: ExamsHistoryModel(
        examTitle: 'Computer Science',
        status: 'Pending',
        isPending: true,
        finalScore: null,
      ),
    ),
    CustomExamCard(
      exHistoryModel: ExamsHistoryModel(
        examTitle: 'Advanced Physics',
        status: 'Pending',
        isPending: true,
        finalScore: null,
      ),
    ),
    CustomExamCard(
      exHistoryModel: ExamsHistoryModel(
        examTitle: 'Machine Learning',
        status: 'Completed',
        isPending: false,
        finalScore: 18,
      ),
    ),
    CustomExamCard(
      exHistoryModel: ExamsHistoryModel(
        examTitle: 'Cuantum Computing',
        status: 'Completed',
        isPending: false,
        finalScore: 15,
      ),
    ),
    CustomExamCard(
      exHistoryModel: ExamsHistoryModel(
        examTitle: 'Data Structures',
        status: 'Completed',
        isPending: false,
        finalScore: 20,
      ),
    ),
  ];
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
                itemCount: exItems.length,
                itemBuilder: (context, index) {
                  return exItems[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
