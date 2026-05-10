import 'dart:ui';

import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/features/auth/onboarding/widgets/action_button.dart';
import 'package:examify/features/auth/onboarding/widgets/const_screens.dart';
import 'package:examify/features/auth/onboarding/widgets/page_indecator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int count = 1;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    // TODO: implement initState
    controller.addListener(() {
      final page = controller.page ?? 0;
      setState(() {
        count = (page + 1).round();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff070B1D),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Container(
          //     decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Color(0xff18123D),
          //           Color(0xff10183A),
          //           Color(0xff070B1D),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned.fill(
          //   child: ImageFiltered(
          //     imageFilter: ImageFilter.blur(sigmaX: 160, sigmaY: 160),
          //     child: DecoratedBox(
          //       decoration: BoxDecoration(
          //         gradient: RadialGradient(
          //           center: const Alignment(0, -0.45),
          //           radius: 0.9,
          //           colors: [
          //             AppColors.mainBlue.withOpacity(0.35),
          //             AppColors.mainIndego.withOpacity(0.24),
          //             Colors.transparent,
          //           ],
          //           stops: const [0.0, 0.45, 1.0],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 38),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.loginScreen);
                      },
                      child: Text(
                        'Skip',

                        style: TextStyle(
                          color: AppColors.white60,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 90.h),
                Expanded(
                  child: PageView(
                    controller: controller,
                    children: [screens[0], screens[1], screens[2]],
                  ),
                ),
                SizedBox(height: 5.h),

                PageIndecator(controller: controller),
                SizedBox(height: 24.h),
                ActionButton(
                  controller: controller,
                  onPressed: () {
                    if (count == 3) {
                      Navigator.pushNamed(context, Routes.loginScreen);
                    }
                    controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(vertical: 24.h),
                  child: Text(
                    '$count of 3',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.white40),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
