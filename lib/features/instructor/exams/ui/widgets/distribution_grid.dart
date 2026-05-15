
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DistributionGrid extends StatelessWidget {
  const DistributionGrid({required this.maxValue, required this.buckets});

  final int maxValue;
  final List<_ScoreBucket> buckets;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: buckets.map((bucket) {
            final heightFactor = maxValue == 0 ? 0.08 : bucket.count / maxValue;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 150.h,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height:
                              (constraints.maxHeight * 0.78) *
                              (bucket.count == 0 ? 0.08 : heightFactor),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff00D3F3), Color(0xff246BFD)],
                            ),
                          ),
                        ),
                      ),
                    ),
                    verticalSpace(6.h),
                    Text(
                      bucket.count.toString(),
                      style: AppTextStyles.white12w400alpha40,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ScoreBucket {
  const _ScoreBucket({required this.label, required this.count});

  final String label;
  final int count;
}
