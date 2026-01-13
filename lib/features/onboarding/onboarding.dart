import 'package:examify/features/onboarding/widgets/action_button.dart';
import 'package:examify/features/onboarding/widgets/const_screens.dart';
import 'package:examify/features/onboarding/widgets/page_indecator.dart';
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
    return Column(
      children: [
        SizedBox(height: 38.h),
        Align(
          alignment: AlignmentGeometry.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 38),
            child: Text(
              'Skip',

              style: TextStyle(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ),
        SizedBox(height: 106.h),
        Expanded(
          child: PageView(
            controller: controller,
            children: [screens[0], screens[1], screens[2]],
          ),
        ),
        SizedBox(height: 68.h),

        PageIndecator(controller: controller),
        SizedBox(height: 24.h),
        ActionButton(
          controller: controller,
          onPressed: () {
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
            style: TextStyle(color: Colors.white.withOpacity(.3)),
          ),
        ),
      ],
    );
  }
}
