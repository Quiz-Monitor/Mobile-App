import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_button.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/login/ui/widgets/donthaveaccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

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
                SizedBox(height: 163.h),
                Image.asset('assets/images/app_logo.png', height: 80.h),
                SizedBox(height: 25.h, width: double.infinity),

                Text(
                  'Welcome Back',
                  style: AppTextStyles.white16w400.copyWith(fontSize: 24.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Sign in to continue  ',
                  style: AppTextStyles.whit14w400alpha60.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 27.h),
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
                Row(
                  children: [
                    Text('Password', style: AppTextStyles.whit14w400alpha60),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.forgotPasswordScreen,
                        );
                      },
                      child: Text(
                        'Forgot Password?  ',
                        style: AppTextStyles.blue14w400,
                      ),
                    ),
                  ],
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
                SizedBox(height: 24.h),
                CustomButton(
                  buttonContent: _isLoading
                      ? CircularProgressIndicator(color: Colors.white , strokeWidth: 3, )
                      : Text('Log in', style: AppTextStyles.white16w400),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushNamed(context, Routes.homeScreen);

                        setState(() {
                          _isLoading = false;
                        });
                      });
                      // Login logic here
                      print(
                        'Email: ${_emailController.text}, Password: ${_passwordController.text}',
                      );
                    }
                  },
                ),
                SizedBox(height: 24.h),
                DontHaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
