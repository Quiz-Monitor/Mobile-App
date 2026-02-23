import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsTypeCard extends StatelessWidget {
  const SettingsTypeCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconUrl,
    this.backColor,
    this.borderColor,
    this.titleColor,
    this.subTitleColor,
    this.iconColor,
    this.onTap
  });
  final String title, subtitle, iconUrl;
  final Color? backColor, borderColor, titleColor, subTitleColor, iconColor;
final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backColor ?? AppColors.white5,
          border: Border.all(color: borderColor ?? AppColors.white10, width: 1.7),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: ListTile(
         
          horizontalTitleGap: 8.w,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.all(0),
          leading: SvgPicture.asset(iconUrl, width: 40.w),
          title: Text(
            title,
            style: AppTextStyles.white14w400alpha70.copyWith(
              color: titleColor ?? Colors.white,
            ),
          ),
          subtitle: SizedBox(
            child: Text(
              subtitle,
      
              style: AppTextStyles.white12w400alpha40.copyWith(
                color: subTitleColor,
                wordSpacing: 0,
                letterSpacing: 0,
              ),
            ),
          ),
          trailing: SizedBox(
            //width: 20,
            child: Icon(Icons.chevron_right_rounded, size: 32, color: iconColor),
          ),
        ),
      ),
    );
  }
}
