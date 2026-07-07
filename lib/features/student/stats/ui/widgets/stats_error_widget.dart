import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/student/stats/logic/cubit/student_stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsErrorWidget extends StatelessWidget {
  final String message;

  const StatsErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: AppColors.greyText, size: 56.r),
            SizedBox(height: 16.h),
            Text('Failed to load statistics', style: AppTextStyles.white16w400),
            SizedBox(height: 8.h),
            Text(
              message,
              style: AppTextStyles.white12w400alpha60,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: () => context.read<StudentStatsCubit>().getStatistics(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.blueBorder,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text('Retry', style: AppTextStyles.white16w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
