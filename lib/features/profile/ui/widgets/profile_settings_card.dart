
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.iconPath,
    required this.title,
  });
  final String iconPath, title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      //height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.white10),
        color: AppColors.white5,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(iconPath, height: 18.h),
            SizedBox(width: 12.w),
            Text(title, style: AppTextStyles.white16w400),
            Spacer(),
            Icon(
              Icons.chevron_right_rounded,
              size: 32,
              color: Colors.white.withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
