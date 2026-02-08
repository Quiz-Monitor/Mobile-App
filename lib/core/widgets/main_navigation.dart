import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/bottom_nav_bar.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/history/ui/views/exams_history.dart';
import 'package:examify/features/home/ui/screens/home_view.dart.dart';
import 'package:examify/features/notifications/ui/screens/notifications_view.dart';
import 'package:examify/features/profile/ui/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Import your actual screen views when ready
// import 'package:examify/features/exam/ui/views/exam_code_entry_view.dart';
// import 'package:examify/features/notifications/ui/views/notifications_view.dart';
// import 'package:examify/features/profile/ui/views/profile_view.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // TODO: Replace these placeholders with your actual screen widgets
  final List<Widget> _screens = [
    // Index 0: Home
    const HomeView(),
    // Index 1: History
    ExamsHistory(),
    // Index 2: Not used (center button)
    const SizedBox.shrink(),
    // Index 3: Notifications
    const NotificationsView(),
    // Index 4: Profile
    const ProfileView(),
  ];

  void _onNavBarTapped(int index) {
    // Handle the center button (index 2) - show exam code entry
    if (index == 2) {
      _showExamCodeEntry();
      return;
    }

    // Update the current screen index
    setState(() {
      _currentIndex = index;
    });
  }

  void _showExamCodeEntry() {
    // Show exam code entry as modal bottom sheet
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,

      backgroundColor: AppColors.primaryBlack.withAlpha(242),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.3177,

        decoration: BoxDecoration(
          color: Colors.transparent,
        
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 13,
            right: 20,
            left: 20,
            bottom: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.white40,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              CustomTextfield(hintText: 'Enter exam code'),
              SizedBox(height: 20.h),
              CustomButton(
                buttonContent: Text(
                  'Join Exam',
                  style: AppTextStyles.white16w400.copyWith(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );

    // Alternative: Navigate using your router (uncomment if you prefer)
    // Navigator.pushNamed(context, Routes.examCodeEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use IndexedStack to preserve state when switching tabs
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
