import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/profile/ui/widgets/settings_type_card.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:flutter_svg/svg.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_cubit.dart';
import 'package:toastification/toastification.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordController = TextEditingController();

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is AccountDeleted) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 10),
            style: ToastificationStyle.fillColored,
            description: RichText(
              text: TextSpan(text: 'Account deleted successfully'),
            ),
            context: context,
            type: ToastificationType.success,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.loginScreen,
            (route) => false,
          );
        } else if (state is ProfileFailure) {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 5),
            style: ToastificationStyle.fillColored,
            description: RichText(text: TextSpan(text: state.message)),
            context: context,
            type: ToastificationType.error,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings', style: AppTextStyles.white20),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 42,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Security', style: AppTextStyles.white14w400alpha70),
              SizedBox(height: 12.h),
              SettingsTypeCard(
                onTap: () {
                  Navigator.pushNamed(context, Routes.changePasswordScreen);
                },
                title: 'Change Password',
                subtitle: 'Update you password',
                iconUrl: 'assets/icons/changepassword.svg',
                iconColor: AppColors.white40,
              ),
              SizedBox(height: 24.h),
              Text('Notifications', style: AppTextStyles.white14w400alpha70),
              SizedBox(height: 12.h),
              SettingsTypeCard(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.notificationsSettingsScreen,
                  );
                },
                title: 'Notifications Settings',
                subtitle: 'Manage your notifications',

                iconUrl: 'assets/icons/notificationsSettings.svg',
                iconColor: AppColors.white40,
              ),
              SizedBox(height: 24.h),
              Text(
                'Danger Zone',
                style: AppTextStyles.white14w400alpha70.copyWith(
                  color: Color(0xffFF6467).withAlpha(175),
                ),
              ),
              SizedBox(height: 12),
              SettingsTypeCard(
                onTap: () {
                  final profileCubit = context.read<ProfileCubit>();
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: AlertDialog(
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.red30alpha,
                              width: 1.71,
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          backgroundColor: AppColors.primaryBlack,
                          iconPadding: EdgeInsets.only(top: 32.h, bottom: 16.h),
                          icon: SvgPicture.asset(
                            'assets/icons/trash.svg',
                            width: 64.w,
                            height: 64.h,
                          ),
                          title: const Text(
                            'Delete Account?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'This action cannot be undone. All your data will be permanently deleted.',
                                style: AppTextStyles.whit14w400alpha60.copyWith(
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16.h),
                              CustomTextfield(
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                labelText: 'Enter password to confirm',
                               // hintText: 'Enter password to confirm',
                                isPassword: true,
                              ),
                            ],
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 8.h,
                          ),
                          actionsPadding: EdgeInsets.all(24.w),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(dialogContext);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white5,
                                        border: Border.all(
                                          color: AppColors.white10,
                                          width: 1.71,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: AppTextStyles.white16w400,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (passwordController.text.isNotEmpty) {
                                        profileCubit.deleteAccount(
                                          password: passwordController.text,
                                        );
                                        Navigator.pop(
                                          dialogContext,
                                        ); // close dialog
                                      } else {
                                        toastification.show(
                                          autoCloseDuration: const Duration(
                                            seconds: 5,
                                          ),
                                          style:
                                              ToastificationStyle.fillColored,
                                          description: RichText(
                                            text: const TextSpan(
                                              text:
                                                  'Please enter your password',
                                            ),
                                          ),
                                          context: dialogContext,
                                          type: ToastificationType.error,
                                        );
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffFB2C36),
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      child: Text(
                                        'Delete',
                                        style: AppTextStyles.white16w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                backColor: AppColors.red5alpha,
                borderColor: AppColors.red30alpha,
                titleColor: Color(0xffFF6467),
                subTitleColor: Color(0xffFF6467).withAlpha(153),
                title: 'Delete Account',
                subtitle: 'Permenently delete your account',
                iconUrl: 'assets/icons/deleteaccount.svg',
                iconColor: Color(0xffFF6467).withAlpha(100),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
