import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileSettingsCard extends StatelessWidget {
  const ProfileSettingsCard({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
  });

  final String iconPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
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
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 32,
                  color: Colors.white.withAlpha(100),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
