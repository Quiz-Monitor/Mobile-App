import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatCard extends StatelessWidget {
  final String iconUrl;
  final String value;
  final String label;
  final Color iconColor;
  final Color borderIconColor;

  const StatCard({
    required this.borderIconColor,
    required this.iconUrl,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: AppColors.white2,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.white10 , width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: borderIconColor.withAlpha(75),
                width: 1.7.w,
              ),
              color: iconColor.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(iconUrl),
          ),
          const Spacer(),
          Text(value, style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp)),
          Text(label, style: AppTextStyles.white12w400alpha40),
        ],
      ),
    );
  }
}
