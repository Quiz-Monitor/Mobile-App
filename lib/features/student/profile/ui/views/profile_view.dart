import 'package:examify/core/routing/routes.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';
import 'package:examify/features/shared/profile/ui/widgets/profile_page_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfilePageBody(
      profile: const ProfileUser(
        fullName: 'Ali Ahamd Taha',
        email: 'ali.ahmed@gmail.com',
        roleLabel: 'Student',
        userId: '929',
        phoneNumber: '+201015023441',
        avatarText: 'AA',
      ),
      onSettingsTap: () {
        Navigator.pushNamed(context, Routes.settingsScreen);
      },
    );
  }
}
