import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreationLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String message;

  const CreationLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Colors.white),
              verticalSpace(16.h),
              Text(message, style: AppTextStyles.white16w400),
            ],
          ),
        ),
      ),
    );
  }
}
