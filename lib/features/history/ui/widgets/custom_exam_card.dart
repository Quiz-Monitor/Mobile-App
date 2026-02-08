import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/history/data/models/exams_history_model.dart';
import 'package:examify/features/history/ui/widgets/custom_history_card_trailing.dart';
import 'package:examify/features/history/ui/widgets/exam_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomExamCard extends StatelessWidget {
  const CustomExamCard({super.key, required this.exHistoryModel});
  final ExamsHistoryModel exHistoryModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [AppColors.white5, AppColors.white2],
          ),
          color: AppColors.white3,
          border: Border.all(color: AppColors.white10, width: 1.7.w),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
          leading: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentGeometry.topLeft,
                end: AlignmentGeometry.bottomRight,
                colors: [AppColors.mainBlue, AppColors.secondaryIndego],
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(child: SvgPicture.asset('assets/icons/docs.svg')),
          ),
          title: Text(
            exHistoryModel.title,
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
          subtitle: Text(
            exHistoryModel.date,
            style: AppTextStyles.whit14w400alpha60.copyWith(fontSize: 12.sp),
          ),
          trailing: exHistoryModel.isPending
              ? PendingState()
              : Customhistoryitemtrailing(
                  grades: exHistoryModel.garade.toString(),
                ),
        ),
      ),
    );
  }
}
