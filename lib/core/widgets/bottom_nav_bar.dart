import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppColors.primaryBlack, // Dark background matching your UI
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
            iconUrl: 'assets/icons/history.svg',
            label: 'History',
            isSelected: currentIndex == 1,
            onTap: onTap,
          ),
          _CenterAddButton(onTap: () => onTap(2)),
          _NavBarItem(
            index: 3,
            iconUrl: 'assets/icons/notifications.svg',
            label: 'Alerts',
            isSelected: currentIndex == 3,
            onTap: onTap,
          ),
          _NavBarItem(
            iconUrl: 'assets/icons/profile.svg',
            index: 4,
            label: 'Profile',
            isSelected: currentIndex == 4,
            onTap: onTap,
          ),
        ],
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
      behavior: HitTestBehavior.deferToChild,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 12),
            SvgPicture.asset(
              iconUrl,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),

            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CenterAddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CenterAddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.blueBorder,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 35),
      ),
    );
  }
}
