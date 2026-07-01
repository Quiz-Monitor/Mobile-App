import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';
import 'package:examify/features/shared/profile/ui/widgets/logout_button.dart';
import 'package:examify/features/shared/profile/ui/widgets/profile_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  title,
                  style: AppTextStyles.white16w400.copyWith(fontSize: 24),
                ),
              ),
              SizedBox(height: 70.h),
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.blueBorder,
                child: Text(profile.initials, style: AppTextStyles.white16w400),
              ),
              SizedBox(height: 24.h),
              Text(profile.fullName, style: AppTextStyles.grey16w400),
              Text(profile.email, style: AppTextStyles.whit14w400alpha60),
              Text(
                'Role: ${profile.roleLabel}',
                style: AppTextStyles.whit14w400alpha60,
              ),
              Text(
                'ID: ${profile.userId}',
                style: AppTextStyles.whit14w400alpha60,
              ),
              Text(
                'Phone Number: ${profile.phoneNumber}',
                style: AppTextStyles.whit14w400alpha60,
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 8.h),
              ProfileSettingsCard(
                iconPath: 'assets/icons/settings.svg',
                title: settingsTitle,
                onTap: onSettingsTap,
              ),
              const SizedBox(height: 30),
              LogoutButton(onTap: onLogoutTap),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
