import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Customhistoryitemtrailing extends StatelessWidget {
  const Customhistoryitemtrailing({super.key,  this.grades});
  final String? grades;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      width: 88.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.blue10alpha,
        border: Border.all(color: AppColors.blue30alpha),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset('assets/icons/radio.svg', height: 16.h, width: 16.h),
          Text(
            '${grades ?? 0}/20',
            style: AppTextStyles.white16w400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
