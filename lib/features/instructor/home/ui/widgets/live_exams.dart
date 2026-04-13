import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LiveExamCard extends StatelessWidget {
  final String title;
  final int studentsCount;

  const LiveExamCard({required this.title, required this.studentsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w ),
      decoration: BoxDecoration(  
        color: const Color(0xff00C950).withAlpha(25),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xff00C950).withAlpha(75),
          width: 1.74.w,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.white16w400.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    verticalSpace(4),
                    Row(
                      children: [
                       SvgPicture.asset('assets/icons/students.svg' , colorFilter: ColorFilter.mode(AppColors.white40, BlendMode.srcIn),),
                        horizontalSpace(4),
                        Text(
                          '$studentsCount students online',
                          style: AppTextStyles.white12w400alpha40,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 9.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff00C950).withAlpha(50),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: const Color(0xff00C950).withAlpha(75) , width: 1.74.w)
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Color(0xff05DF72),
                          shape: BoxShape.circle,
                        ),
                      ),
                      horizontalSpace(6),
                      Text(
                        'Live',
                        style: TextStyle(
                          color: const Color(0xff05DF72),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           Divider(color: Colors.white12 , thickness: 1.74.w,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Monitor Exam', style: AppTextStyles.white12w400alpha40),
              Icon(
                Icons.arrow_forward_rounded,
                color: const Color(0xff05DF72),
                size: 18.sp,
              ),
            ],
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}
