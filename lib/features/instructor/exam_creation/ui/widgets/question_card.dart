import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionCard extends StatelessWidget {
  final QuestionLocalDto question;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.onTap,
    required this.onDelete,
  });

  static const _typeColors = {
    'mcq_single': Color(0xFF3B82F6),
    'mcq_multiple': Color(0xFF8B5CF6),
    'true_false': Color(0xFF10B981),
    'short_answer': Color(0xFFF59E0B),
    'essay': Color(0xFFEF4444),
  };

  String _formatType(String type) => switch (type) {
    'mcq_single' => 'MCQ Single',
    'mcq_multiple' => 'MCQ Multi',
    'true_false' => 'True / False',
    'short_answer' => 'Short Answer',
    'essay' => 'Essay',
    _ => type,
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColors[question.type] ?? AppColors.mainBlue;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white5,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: color,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    _formatType(question.type),
                    style: TextStyle(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${question.points} pts',
                  style: AppTextStyles.white12w400alpha40.copyWith(
                    color: AppColors.mainGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.white40,
                  size: 18.sp,
                ),
              ],
            ),
            verticalSpace(12.h),
            Text(
              question.text,
              style: AppTextStyles.white16w400,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            verticalSpace(8.h),
            Row(
              children: [
                if (question.choices.isNotEmpty)
                  Text(
                    '${question.choices.length} choices',
                    style: AppTextStyles.white12w400alpha40.copyWith(
                      color: AppColors.white40,
                    ),
                  ),
                const Spacer(),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withAlpha(20),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
