import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/widgets/bottom_nav_bar.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_cubit.dart';
import 'package:examify/features/student/join_exam/ui/widgets/join_exam_bottom_sheet.dart';
import 'package:examify/features/student/history/ui/views/exams_history.dart';
import 'package:examify/features/student/history/logic/cubit/student_results_cubit.dart';
import 'package:examify/features/student/home/ui/screens/home_view.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_cubit.dart';
import 'package:examify/features/student/notifications/ui/screens/notifications_view.dart';
import 'package:examify/features/shared/profile/ui/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final TextEditingController _examCodeController = TextEditingController();

  final List<Widget> _screens = [
    // Index 0: Home
    BlocProvider(
      create: (_) => getit<StudentExamCubit>()..getUpcomingExams(),
      child: const HomeView(),
    ),
    // Index 1: History
    BlocProvider(
      create: (_) => getit<StudentResultsCubit>()..getExamHistory(),
      child: const ExamsHistory(),
    ),
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
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.primaryBlack.withAlpha(242),
      builder: (context) => BlocProvider(
        create: (_) => getit<JoinExamCubit>(),
        child: JoinExamBottomSheet(
          examCodeController: _examCodeController,
          onJoinSuccess: () {
            if (!mounted) {
              return;
            }

            setState(() {
              _currentIndex = 1;
            });
            _examCodeController.clear();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _examCodeController.dispose();
    super.dispose();
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
