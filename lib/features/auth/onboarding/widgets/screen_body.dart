import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Package extends StatefulWidget {
  final String? imagePath, heading, subTitle;
  const Package({super.key, this.imagePath, this.subTitle, this.heading});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 256.h,
          width: 256.w,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: child,
              );
            },
            child: SvgPicture.asset(widget.imagePath!),
          ),
        ),
        SizedBox(height: 48.h),
        Text(
          widget.heading ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Text(
            textAlign: TextAlign.center,
            widget.subTitle ?? '',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.white40,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
