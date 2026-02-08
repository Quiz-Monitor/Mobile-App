import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/notifications/ui/widgets/notifications_card_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications', style: AppTextStyles.white16w400.copyWith(fontSize: 20.sp)),
            SizedBox(height: 48.h),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                 return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: NotificationsCardItem(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
