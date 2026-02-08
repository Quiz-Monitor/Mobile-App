import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool _examReminders = true;
  bool _gradeUpdates = true;
  bool _systemUpdates = false;

  int _selectedReminderIndex = 1; // 15m selected by default
  final List<String> _reminderTimes = ['10m', '15m', '30m', '1h'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification Settings',
          style:
              AppTextStyles.white20, // Assuming exists, otherwise use similar
        ),
        centerTitle: false, // Left aligned usually in iOS/Settings
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Text('Notification Types', style: AppTextStyles.whit14w400alpha60),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white5,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(width: 1.7.w, color: AppColors.white10),
              ),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: 'Exam Reminders',
                    subtitle: 'Get notified before exams start',
                    value: _examReminders,
                    onChanged: (val) => setState(() => _examReminders = val),
                    icon: 'assets/icons/examreminder.svg',
                  ),
                  Divider(color: AppColors.white5, height: 1.7.h),
                  _buildSwitchTile(
                    title: 'Grade Updates',
                    subtitle: 'Notifications when grades are available',
                    value: _gradeUpdates,
                    onChanged: (val) => setState(() => _gradeUpdates = val),
                    icon: 'assets/icons/gradeUpdate.svg',
                  ),
                  Divider(color: AppColors.white5, height: 1.7.h),
                  _buildSwitchTile(
                    title: 'System Updates',
                    subtitle: 'Important system announcements',
                    value: _systemUpdates,
                    onChanged: (val) => setState(() => _systemUpdates = val),
                    icon: 'assets/icons/systemUpdates.svg',
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Text('Reminder Timing', style: AppTextStyles.whit14w400alpha60),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.white5,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(width: 1.7.w, color: AppColors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notify me before exam starts',
                    style: AppTextStyles.white14w400alpha70.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(_reminderTimes.length, (index) {
                      return _buildReminderChip(index);
                    }),
                  ),
                ],
              ),
            ),
            Spacer(),
            CustomButton(
              buttonContent: Text(
                'Save Changes',
                style: AppTextStyles.white16w400,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 52.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required String icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: [
          SvgPicture.asset(icon, width: 40.w, height: 40.h),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.whit14w400alpha60.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(subtitle, style: AppTextStyles.white12w400alpha40),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.blueBorder,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.white10,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderChip(int index) {
    bool isSelected = _selectedReminderIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedReminderIndex = index),
      child: Container(
        width: 64.w, // Approx width
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueBorder
              : AppColors.white5, // Filled blue if selected
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: 1.7.w,
            color: isSelected ? AppColors.blueBorder : AppColors.white10,
          ),
        ),
        child: Center(
          child: Text(
            _reminderTimes[index],
            style: isSelected
                ? AppTextStyles.white16w400.copyWith(fontSize: 14.sp)
                : AppTextStyles.whit14w400alpha60.copyWith(fontSize: 14.sp),
          ),
        ),
      ),
    );
  }
}
