import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProctoringSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ProctoringSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.white40, size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.white16w400.copyWith(fontSize: 14.sp , color: AppColors.white90),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.white40, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.mainBlue,
            inactiveTrackColor: AppColors.white10,
            inactiveThumbColor: AppColors.white40,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
