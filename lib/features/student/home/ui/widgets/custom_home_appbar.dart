import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHomeAppbar extends StatelessWidget {
  const CustomHomeAppbar({super.key});

  Future<String> _getDisplayName() async {
    final storage = getit<SessionStorage>();
    final fullName = (await storage.getFullName())?.trim();
    if (fullName != null && fullName.isNotEmpty) {
      return fullName;
    }

    final email = (await storage.getEmail())?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getDisplayName(),
      builder: (context, snapshot) {
        final name = snapshot.data ?? 'User';
        final trimmed = name.trim();
        final initial = trimmed.isNotEmpty
            ? trimmed.substring(0, 1).toUpperCase()
            : 'U';

        return Row(
          children: [
            InkWell(
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.blueBorder, AppColors.mainIndego],
                  ),
                ),
                child: Center(
                  child: Text(initial, style: AppTextStyles.white16w400),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text('Hi, $name', style: AppTextStyles.white16w400),
          ],
        );
      },
    );
  }
}
