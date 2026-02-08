import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/profile/ui/widgets/logout_button.dart';
import 'package:examify/features/profile/ui/widgets/profile_settings_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                'Profile',
                style: AppTextStyles.white16w400.copyWith(fontSize: 24),
              ),
            ),
            SizedBox(height: 70.h),
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.blueBorder,
              child: Text('AA', style: AppTextStyles.white16w400),
            ),
            SizedBox(height: 24.h),
            Text('Ali Ahamd Taha', style: AppTextStyles.grey16w400),
            Text('ali.ahmed@gmail.com', style: AppTextStyles.whit14w400alpha60),
            Text('Role: Student', style: AppTextStyles.whit14w400alpha60),
            Text('ID: 929', style: AppTextStyles.whit14w400alpha60),
            Text('Phone Number: +201015023441', style: AppTextStyles.whit14w400alpha60),
            SizedBox(height: 20.h),
            ProfileSettingsCard(
              iconPath: 'assets/icons/editprofile.svg',
              title: 'Edit Profile',
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, Routes.settingsScreen);
              },
              child: ProfileSettingsCard(
                iconPath: 'assets/icons/settings.svg',
                title: 'Settings',
              ),
            ),
            SizedBox(height: 30),
            LogoutButton(),
          ],
        ),
      ),
    );
  }
}
