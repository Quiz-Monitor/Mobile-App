import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/signup/ui/widgets/alreadyhaveaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _islaoding = false;
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 70.h),
                Image.asset('assets/images/app_logo.png', height: 80.h),
                SizedBox(height: 25.h, width: double.infinity),

                Text(
                  'Create Account',
                  style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Sign up to get started',
                  style: AppTextStyles.whit14w400alpha60.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 27.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Full Name',
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                ),
                SizedBox(height: 8.h),
                CustomTextfield(
                  controller: _nameController,
                  hintText: 'Ali Ahmad Taha Saed',
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text('Email', style: AppTextStyles.whit14w400alpha60),
                ),
                SizedBox(height: 8.h),
                CustomTextfield(
                  controller: _emailController,
                  hintText: 'your.email@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Password',
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                ),
                SizedBox(height: 8.h),

                CustomTextfield(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Confirm Password',
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                ),
                SizedBox(height: 8.h),

                CustomTextfield(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm your password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.h),
                CustomButton(
                  buttonContent: _islaoding
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Sign Up', style: AppTextStyles.white16w400),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _islaoding = true;
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.loginScreen,
                        );
                        setState(() {
                          _islaoding = false;
                        });
                      });
                      // Sign Up logic here
                      print(
                        'Name: ${_nameController.text}, Email: ${_emailController.text}, Password: ${_passwordController.text}',
                      );
                    }
                  },
                ),
                SizedBox(height: 24.h),
                AlreadyHaveAccount(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
