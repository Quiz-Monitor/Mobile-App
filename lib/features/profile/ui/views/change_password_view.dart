import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _hasMinLength = false;
  bool _hasUppercase = false;
  bool _hasLowercase = false;
  bool _hasNumber = false;

  void _validatePassword(String value) {
    setState(() {
      _hasMinLength = value.length >= 8;
      _hasUppercase = value.contains(RegExp(r'[A-Z]'));
      _hasLowercase = value.contains(RegExp(r'[a-z]'));
      _hasNumber = value.contains(RegExp(r'[0-9]'));
    });
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password', style: AppTextStyles.white20),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/changepassword.svg',
                      height: 80.h,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Enter your current password and choose a new secure password',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.grey16w400,
                  ),
                  SizedBox(height: 28.h),

                  // Current Password
                  Text(
                    'Current Password',
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    hintText: 'Enter current password',
                    isPassword: true,
                    controller: _currentPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your current password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // New Password
                  Text('New Password', style: AppTextStyles.whit14w400alpha60),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    hintText: 'Enter new password',
                    isPassword: true,
                    controller: _newPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (!_hasMinLength ||
                          !_hasUppercase ||
                          !_hasLowercase ||
                          !_hasNumber) {
                        return 'Password does not meet requirements';
                      }
                      return null;
                    },
                    // We need to listen to changes on the controller or use onChanged if CustomTextfield supports it.
                    // CustomTextfield doesn't seem to expose onChanged, so we use controller listener.
                  ),

                  // Bind listener in initState is better, or use ValueListenableBuilder.
                  // But since CustomTextfield is a StatefulWidget, let's wrap it?
                  // Wait, CustomTextField doesn't expose onChanged.
                  // I will add a listener to the controller in initState.
                  SizedBox(height: 16.h),

                  // Confirm New Password
                  Text(
                    'Confirm New Password',
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                  SizedBox(height: 8.h),
                  CustomTextfield(
                    hintText: 'Re-enter new password',
                    isPassword: true,
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Password Requirements
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.white5,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.white10,
                        width: 1.7.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password must contain:',
                          style: AppTextStyles.whit14w400alpha60,
                        ),
                        SizedBox(height: 8.h),
                        _buildRequirementRow(
                          'At least 8 characters',
                          _hasMinLength,
                        ),
                        SizedBox(height: 4.h),
                        _buildRequirementRow(
                          'One uppercase letter',
                          _hasUppercase,
                        ),
                        SizedBox(height: 4.h),
                        _buildRequirementRow(
                          'One lowercase letter',
                          _hasLowercase,
                        ),
                        SizedBox(height: 4.h),
                        _buildRequirementRow('One number', _hasNumber),
                      ],
                    ),
                  ),
                  SizedBox(height: 28.h),

                  CustomButton(
                    buttonContent: Text(
                      'Change Password',
                      style: AppTextStyles.white16w400.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Implement change password logic here
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(() {
      _validatePassword(_newPasswordController.text);
    });
  }

  Widget _buildRequirementRow(String text, bool isMet) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMet ? 2.3.w : 0.w),
          width: 16.w,
          height: 16.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isMet ? AppColors.greenBorder : AppColors.white10,
              width: 1.7.w,
            ),
            color: isMet ? AppColors.greenAlpha20 : AppColors.white5,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: isMet ? Container(
            width: 8.w,
            height: 8.h,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.mainGreen,
            ),
          ) : null,
        ),
       
        SizedBox(width: 8.w),
        Text(
          text,
          style: isMet
              ? AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.mainGreen,
                )
              : AppTextStyles.white12w400alpha40.copyWith(
                  color: AppColors.white40,
                ),
        ),
      ],
    );
  }
}
