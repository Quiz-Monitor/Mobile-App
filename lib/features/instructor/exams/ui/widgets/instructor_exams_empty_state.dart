import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamsEmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const InstructorExamsEmptyState({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: [
          SizedBox(height: 140.h),
          Center(
            child: Text(
              'There are no exams yet.\nPull down to refresh.',
              style: AppTextStyles.white20,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
