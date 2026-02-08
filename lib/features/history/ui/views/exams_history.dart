import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/history/data/models/exams_history_model.dart';
import 'package:examify/features/history/ui/widgets/custom_evaluation_card.dart';
import 'package:examify/features/history/ui/widgets/custom_exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExamsHistory extends StatelessWidget {
  ExamsHistory({super.key});
  List<CustomExamCard> exItems = [
    CustomExamCard(exHistoryModel: ExamsHistoryModel(
      title: 'Computer Science',
      date: 'Nov 28, 2024',
      isPending: true,
    )),
    CustomExamCard(exHistoryModel: ExamsHistoryModel(
      title: 'Advanced Physics',
      date: 'Nov 25, 2024',
      isPending: true,
    )),
    CustomExamCard(exHistoryModel: ExamsHistoryModel(
      title: 'Machine Learning',
      date: 'Nov 20, 2024',
      isPending: false,
      garade: 18,
    )),
    CustomExamCard(exHistoryModel: ExamsHistoryModel(
      title: 'Cuantum Computing',
      date: 'Nov 20, 2024',
      isPending: false,
      garade: 15
    )),
    CustomExamCard(exHistoryModel: ExamsHistoryModel(
      title: 'Data Structures',
      date: 'Nov 20, 2024',
      isPending: false,
      garade: 20
    )),
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
