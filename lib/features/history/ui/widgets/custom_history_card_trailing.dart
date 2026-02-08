
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Customhistoryitemtrailing extends StatelessWidget {
  const Customhistoryitemtrailing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.blue10alpha,
        border: Border.all(color: AppColors.blue30alpha),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
           
            
            'assets/icons/radio.svg',
            height: 16.h,
            width: 16.h,
          ),
          Text(
            '18/20',
            style: AppTextStyles.white16w400.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
