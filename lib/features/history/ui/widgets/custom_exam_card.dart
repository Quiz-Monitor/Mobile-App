import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/history/ui/widgets/custom_history_card_trailing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomExamCard extends StatelessWidget {
  const CustomExamCard({super.key, required this.isPending});
  final bool isPending;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.mainBlue, AppColors.secondaryIndego],
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Center(child: SvgPicture.asset('assets/icons/docs.svg')),
        ),
        title: Text(
          'Computer Science',
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
        ),
        subtitle: Text(
          'Nov 28 , 2024',
          style: AppTextStyles.whit14w400alpha60.copyWith(fontSize: 12.sp),
        ),
        trailing: isPending ? PendingState() : Customhistoryitemtrailing(),
      ),
    );
  }
}

class PendingState extends StatelessWidget {
  const PendingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 88.w,
      decoration: BoxDecoration(
        color: AppColors.brown20alpha,
        border: Border.all(color: AppColors.brown30alpha),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(child: Text('Pending', style: AppTextStyles.brown16w600)),
    );
  }
}
