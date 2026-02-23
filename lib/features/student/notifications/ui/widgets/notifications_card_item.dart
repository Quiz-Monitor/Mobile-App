import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsCardItem extends StatelessWidget {
  const NotificationsCardItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white5,
        border: Border.all(color: AppColors.white10, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        leading: SvgPicture.asset(
          'assets/icons/rednotiIcon.svg',
          width: 40.w,
          height: 40.h,
        ),
        title: Text(
          'Advanced Physics starts in 10 minutes',
          style: AppTextStyles.white14w400alpha70,
        ),

        subtitle: Text( 'Now', style: AppTextStyles.white12w400alpha40 ,),
      ),
    );
  }
}
