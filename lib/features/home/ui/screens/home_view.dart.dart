import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/home/data/model/exam_model.dart';
import 'package:examify/features/home/ui/widgets/custom_home_appbar.dart';
import 'package:examify/features/home/ui/widgets/upcoming_exams_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(child: CustomHomeAppbar()),
          SizedBox(height: 20.h),
          CustomTextfield(hintText: 'Enter Code...'),
          SizedBox(height: 20.h),
          Text('Upcoming Exams', style: AppTextStyles.white16w400),
          SizedBox(height: 16.h),
          Expanded(
            child: SingleChildScrollView(
             // physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  UpcomingExamsCard(
                    examModel: ExamModel(
                      title: 'Advanced Physics',
                      prof: 'Dr. Sarah Mitchel',
                      isLive: true,
                      dateTime: DateTime(2026, 2, 5, 18, 30),
                    ),
                  ),
                  SizedBox(height: 10),
                  UpcomingExamsCard(
                    examModel: ExamModel(
                      title: 'Quantum Computing',
                      prof: 'Prof. James Chen',
                      isLive: false,
                      dateTime: DateTime(2026, 2, 4, 3, 0),
                    ),
                  ),
                  SizedBox(height: 10),
                  UpcomingExamsCard(
                    examModel: ExamModel(
                      title: 'Machine Learning',
                      prof: 'Dr. Emily Rodriguez',
                      isLive: true,
                      dateTime: DateTime(2026, 2, 1, 3, 9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
