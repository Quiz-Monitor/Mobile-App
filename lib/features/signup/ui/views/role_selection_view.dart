import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/features/signup/ui/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  // 0: Educator, 1: Student, -1: None
  int _selectedRoleIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlack,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              Text(
                'Select Your Role',
                style: AppTextStyles.white16w400.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Choose how you want to continue',
                style: AppTextStyles.whit14w400alpha60.copyWith(
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 42.h),

              // Educator Card
              RoleCard(
                title: 'Instructor',
                subtitle: 'Create and monitor exams',
                icon: 'assets/images/educator_logo.svg',
                isSelected: _selectedRoleIndex == 0,
                onTap: () {
                  setState(() {
                    _selectedRoleIndex = 0;
                  });
                },
              ),

              SizedBox(height: 20.h),

              // Student Card
              RoleCard(
                title: 'Student',
                subtitle: 'Take exams and track results',
                icon: 'assets/images/book.svg',
                isSelected: _selectedRoleIndex == 1,
                onTap: () {
                  setState(() {
                    _selectedRoleIndex = 1;
                  });
                },
              ),

              const Spacer(),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  Navigator.pushNamed(context, Routes.signupScreen);
                  // TODO: Navigate to next screen
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
