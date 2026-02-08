import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/profile/ui/widgets/settings_type_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTextStyles.white20),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 42),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Security', style: AppTextStyles.white14w400alpha70),
            SizedBox(height: 12.h),
            SettingsTypeCard(
              onTap: () {
                Navigator.pushNamed(context, Routes.changePasswordScreen);
              },
              title: 'Change Password',
              subtitle: 'Update you password',
              iconUrl: 'assets/icons/changepassword.svg',
              iconColor: AppColors.white40,
            ),
            SizedBox(height: 24.h),
            Text('Notifications', style: AppTextStyles.white14w400alpha70),
            SizedBox(height: 12.h),
            SettingsTypeCard(
              title: 'Notifications Settings',
              subtitle: 'Manage your notifications',

              iconUrl: 'assets/icons/notificationsSettings.svg',
              iconColor: AppColors.white40,
            ),
            SizedBox(height: 24.h),
            Text(
              'Danger Zone',
              style: AppTextStyles.white14w400alpha70.copyWith(
                color: Color(0xffFF6467).withAlpha(175),
              ),
            ),
            SizedBox(height: 12),
            SettingsTypeCard(
              backColor: AppColors.red5alpha,
              borderColor: AppColors.red30alpha,
              titleColor: Color(0xffFF6467),
              subTitleColor: Color(0xffFF6467).withAlpha(153),
              title: 'Delete Account',
              subtitle: 'Permenently delete your account',
              iconUrl: 'assets/icons/deleteaccount.svg',
              iconColor: Color(0xffFF6467).withAlpha(100),
            ),
          ],
        ),
      ),
    );
  }
}
