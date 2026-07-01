import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/home/ui/views/instructor_home_dashboard_view.dart';
import 'package:examify/features/instructor/navigation/ui/widgets/instructor_bottom_nav_bar.dart';
import 'package:examify/features/shared/profile/ui/views/profile_view.dart';
import 'package:examify/features/instructor/reports/ui/views/instructor_reports_view.dart';
import 'package:flutter/material.dart';

class InstructorNavigation extends StatefulWidget {
  const InstructorNavigation({super.key});

  @override
  State<InstructorNavigation> createState() => _InstructorNavigationState();
}

class _InstructorNavigationState extends State<InstructorNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const InstructorHomeView(),
    const InstructorExamsView(),
    const InstructorReportsView(),
    const ProfileView(),
  ];

  void _onNavBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: InstructorBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTapped,
      ),
    );
  }
}
