import 'package:examify/features/onboarding/widgets/const_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndecator extends StatelessWidget {
  const PageIndecator({super.key, required this.controller});

  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      
      controller: controller,
      count: screens.length,
      effect: ExpandingDotsEffect(
        spacing: 8,
        dotHeight: 8.h,
        dotWidth: 8.w,
        activeDotColor: Color(0xffffffff),
        dotColor: Colors.white.withAlpha((255 * .2).round()),
      ),
    );
  }
}
