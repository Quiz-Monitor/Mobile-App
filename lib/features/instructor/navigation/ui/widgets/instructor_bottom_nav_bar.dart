import 'package:examify/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InstructorBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const InstructorBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        bottom: true,
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavBarItem(
              index: 0,
              iconUrl: 'assets/icons/Icon.svg',
              label: 'Home',
              isSelected: currentIndex == 0,
              onTap: onTap,
            ),
            _NavBarItem(
              index: 1,
              iconUrl: 'assets/icons/docs.svg',
              label: 'Exams',
              isSelected: currentIndex == 1,
              onTap: onTap,
            ),
            _NavBarItem(
              index: 2,
              iconUrl: 'assets/icons/stats2.svg',
              label: 'Stats',
              isSelected: currentIndex == 2,
              onTap: onTap,
            ),
            _NavBarItem(
              index: 3,
              iconUrl: 'assets/icons/profile.svg',
              label: 'Profile',
              isSelected: currentIndex == 3,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final String label;
  final String iconUrl;
  final bool isSelected;
  final Function(int) onTap;

  const _NavBarItem({
    required this.iconUrl,
    required this.index,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.blueBorder : AppColors.greyIcon;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Make column responsive to content
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              iconUrl,
              height: 24.h,
              width: 24.w,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: 3.h),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
