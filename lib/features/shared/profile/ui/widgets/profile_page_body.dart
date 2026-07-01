import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';
import 'package:examify/features/shared/profile/ui/widgets/logout_button.dart';
import 'package:examify/features/shared/profile/ui/widgets/profile_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({
    super.key,
    required this.profile,
    required this.onSettingsTap,
    this.onEditProfileTap,
    this.onLogoutTap,
    this.title = 'Profile',
    this.editProfileTitle = 'Edit Profile',
    this.settingsTitle = 'Settings',
  });

  final ProfileUser profile;
  final VoidCallback onSettingsTap;
  final VoidCallback? onEditProfileTap;
  final VoidCallback? onLogoutTap;
  final String title;
  final String editProfileTitle;
  final String settingsTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.textblue, AppColors.mainIndego],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    profile.initials,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              _buildPersonalInfoCard(),
              SizedBox(height: 21.h),
              ProfileSettingsCard(
                iconPath: 'assets/icons/settings.svg',
                title: settingsTitle,
                onTap: onSettingsTap,
              ),
              SizedBox(height: 24.h),
              LogoutButton(onTap: onLogoutTap),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white3,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white10 , width: 1.74.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 20.w, 8.h),
            child: Text(
              'PERSONAL INFORMATION',
              style: AppTextStyles.white12w400alpha40.copyWith(
                letterSpacing: 0.6.w,
              ),
            ),
          ),
          _PersonalInfoRow(
            iconPath: 'assets/icons/personblue.svg',
            title: 'Full Name',
            value: profile.fullName,
          ),
          Divider(color: AppColors.white10, height: 1),
          _PersonalInfoRow(
            iconPath: 'assets/icons/email.svg',
            title: 'Email',
            value: profile.email,
          ),
          Divider(color: AppColors.white10, height: 1),
          _PersonalInfoRow(
            iconPath: 'assets/icons/phone.svg',
            title: 'Phone',
            value: profile.phoneNumber,
          ),
          Divider(color: AppColors.white10, height: 1),
          _PersonalInfoRow(
            iconPath: 'assets/icons/role.svg',
            title: 'Role',
            value: profile.roleLabel,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _PersonalInfoRow extends StatelessWidget {
  const _PersonalInfoRow({
    required this.iconPath,
    required this.title,
    required this.value,
  });

  final String iconPath;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.mainBlue.withAlpha(45),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.mainBlue.withAlpha(65), width: 1.74.w),
            ),
            child: SvgPicture.asset(iconPath, height: 24.w, width: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.white12w400alpha60
                ),
                Text(
                  value,
                  style: AppTextStyles.white16w400.copyWith(fontSize: 15.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
