import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionCard extends StatelessWidget {
  final QuestionLocalDto question;
  final int index;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    this.onTap,
    this.onDelete,
  });

  String _formatType(String type) => switch (type) {
    'mcq_single' => 'MCQ (Single Correct)',
    'mcq_multiple' => 'MCQ (Multiple Correct)',
    'true_false' => 'True / False',
    'short_answer' => 'Short Answer',
    'essay' => 'Essay',
    _ => type,
  };

  @override
  Widget build(BuildContext context) {
    final color = AppColors.mainBlue; // Using standard blue to match the design
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.white10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: color.withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: color.withAlpha(200), width: 1.5),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: color,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question.text,
                    style: AppTextStyles.white16w400.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpace(4.h),
                  Text(
                    '${_formatType(question.type)} · ${question.points} pts',
                    style: AppTextStyles.white12w400alpha60,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(Icons.edit_outlined, color: color, size: 22.sp),
              ),
            ),
            if (onDelete != null) ...[
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: onDelete,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
