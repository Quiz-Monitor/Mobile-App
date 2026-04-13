import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/features/auth/role_selection/data/models/user_role.dart';
import 'package:examify/features/auth/role_selection/logic/role_cubit.dart';
import 'package:examify/features/auth/role_selection/ui/widgets/role_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  // 0: Instructor, 1: Student
  int _selectedRoleIndex = 1;
  bool isLoading = false;

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
                onTap: () => setState(() => _selectedRoleIndex = 0),
              ),

              SizedBox(height: 20.h),

              // Student Card
              RoleCard(
                title: 'Student',
                subtitle: 'Take exams and track results',
                icon: 'assets/images/book.svg',
                isSelected: _selectedRoleIndex == 1,
                onTap: () => setState(() => _selectedRoleIndex = 1),
              ),

              const Spacer(),
              CustomButton(
                buttonContent: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Continue', style: AppTextStyles.white16w400),
                onPressed: () {
                  setState(() => isLoading = true);

                  final selectedRole = _selectedRoleIndex == 0
                      ? UserRole.instructor
                      : UserRole.student;
                  context.read<RoleCubit>().selectRole(selectedRole);

                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      Navigator.pushNamed(context, Routes.signupScreen);
                      setState(() => isLoading = false);
                    }
                  });
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
