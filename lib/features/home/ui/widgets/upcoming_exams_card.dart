
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/home/data/model/exam_model.dart';
import 'package:examify/features/home/ui/widgets/exam_card_state.dart';
import 'package:flutter/material.dart';

class UpcomingExamsCard extends StatelessWidget {
  const UpcomingExamsCard({super.key, required this.examModel});
  final ExamModel examModel;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.9,
      child: Container(
        decoration: BoxDecoration(
          gradient: examModel.isLive
              ? LinearGradient(
                  colors: [AppColors.greenAlpha10, AppColors.blueAlpha10],
                )
              : null,
          color: !examModel.isLive ? AppColors.white5 : null,
          border: Border.all(color: AppColors.white10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(examModel.title, style: AppTextStyles.white16w400),
              Text('Starts in', style: AppTextStyles.whit14w400alpha60),
              Align(
                alignment: AlignmentGeometry.center,
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(

                          text: examModel.dateTime.day.toString().padLeft(
                            2,
                            '0',
                          ),
                          style: AppTextStyles.blue14w400.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        TextSpan(
                          text: 'd',
                          style: AppTextStyles.grey16w400.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(text: ' : ', style: AppTextStyles.blue14w400),
                        TextSpan(
                          text: examModel.dateTime.hour.toString().padLeft(
                            2,
                            '0',
                          ),
                          style: AppTextStyles.blue14w400.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        TextSpan(
                          text: 'h',
                          style: AppTextStyles.grey16w400.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(text: ' : ', style: AppTextStyles.blue14w400),
                        TextSpan(
                          text: examModel.dateTime.minute.toString().padLeft(
                            2,
                            '0',
                          ),
                          style: AppTextStyles.blue14w400.copyWith(
                            fontSize: 24,
                          ),
                        ),
                        TextSpan(
                          text: 'm',
                          style: AppTextStyles.grey16w400.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(examModel.prof, style: AppTextStyles.grey16w400),
                  Spacer(),
                  ExamCardState(isLive: examModel.isLive),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
