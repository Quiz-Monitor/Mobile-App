import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LiveExamCard extends StatelessWidget {
  final ExamModel exam;

  const LiveExamCard({super.key, required this.exam});

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  Future<void> _copyExamCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: exam.examCode));

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryBlack,
        content: Text('Exam code copied: ${exam.examCode}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xff00C950).withAlpha(25),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xff00C950).withAlpha(75),
          width: 1.74.w,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: AppTextStyles.white16w400.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    verticalSpace(4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/students.svg',
                          colorFilter: ColorFilter.mode(
                            AppColors.white40,
                            BlendMode.srcIn,
                          ),
                        ),
                        horizontalSpace(4),
                        Text(
                          'Ends at ${_formatTime(exam.endTime)}',
                          style: AppTextStyles.white12w400alpha40,
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xff00C950).withAlpha(50),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: const Color(0xff00C950).withAlpha(75),
                      width: 1.74.w,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: const BoxDecoration(
                          color: Color(0xff05DF72),
                          shape: BoxShape.circle,
                        ),
                      ),
                      horizontalSpace(6),
                      Text(
                        'Live',
                        style: TextStyle(
                          color: const Color(0xff05DF72),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Colors.white12, thickness: 1.74.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(exam.examCode, style: AppTextStyles.white12w400alpha40),
                  horizontalSpace(8),
                  InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () => _copyExamCode(context),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: Icon(
                        Icons.copy_rounded,
                        color: AppColors.white40,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: const Color(0xff05DF72),
                    size: 18.sp,
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(24),
        ],
      ),
    );
  }
}
