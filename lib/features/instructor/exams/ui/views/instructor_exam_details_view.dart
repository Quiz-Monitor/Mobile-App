import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructorExamDetailsView extends StatefulWidget {
  const InstructorExamDetailsView({super.key, required this.exam});

  final ExamModel exam;

  @override
  State<InstructorExamDetailsView> createState() =>
      _InstructorExamDetailsViewState();
}

class _InstructorExamDetailsViewState extends State<InstructorExamDetailsView> {
  late Future<List<InstructorExamResultModel>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = _loadResults();
  }

  Future<List<InstructorExamResultModel>> _loadResults() async {
    final repo = getit<InstructorExamsRepo>();
    final result = await repo.getExamResults(widget.exam.examId);

    return result.when(
      success: (rows) => rows,
      failure: (_) => const <InstructorExamResultModel>[],
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized == 'clean') return const Color(0xff05DF72);
    if (normalized == 'suspected') return const Color(0xffF59E0B);
    if (normalized == 'confirmed') return const Color(0xffFF6B6B);
    return AppColors.white60;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Exam Details', style: AppTextStyles.white20),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: FutureBuilder<List<InstructorExamResultModel>>(
            future: _resultsFuture,
            builder: (context, snapshot) {
              final results =
                  snapshot.data ?? const <InstructorExamResultModel>[];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.exam.title, style: AppTextStyles.white20),
                  verticalSpace(8.h),
                  Text(
                    widget.exam.description,
                    style: AppTextStyles.whit14w400alpha60,
                  ),
                  verticalSpace(12.h),
                  Text(
                    'Code: ${widget.exam.examCode}',
                    style: AppTextStyles.white12w400alpha40.copyWith(
                      color: AppColors.white60,
                    ),
                  ),
                  verticalSpace(6.h),
                  Text(
                    'Starts: ${formatDate(widget.exam.startTime)}',
                    style: AppTextStyles.white12w400alpha40.copyWith(
                      color: AppColors.white60,
                    ),
                  ),
                  verticalSpace(6.h),
                  Text(
                    'Enrolled students: ${results.length}',
                    style: AppTextStyles.white16w400,
                  ),
                  verticalSpace(12.h),
                  Divider(color: AppColors.white10, thickness: 1.2.w),
                  verticalSpace(12.h),
                  Expanded(
                    child: snapshot.connectionState == ConnectionState.waiting
                        ? const Center(child: CircularProgressIndicator())
                        : results.isEmpty
                        ? Center(
                            child: Text(
                              'No students enrolled yet.',
                              style: AppTextStyles.white16w400,
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: results.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final row = results[index];
                              final statusColor = _statusColor(
                                row.cheatingStatus,
                              );

                              return Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: AppColors.white5,
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.white10,
                                    width: 1.w,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            row.studentName,
                                            style: AppTextStyles.white16w400,
                                          ),
                                          verticalSpace(4.h),
                                          Text(
                                            'Score: ${row.finalScore.toStringAsFixed(2)}',
                                            style: AppTextStyles
                                                .white12w400alpha40,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withAlpha(35),
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        border: Border.all(
                                          color: statusColor.withAlpha(120),
                                        ),
                                      ),
                                      child: Text(
                                        row.cheatingStatus,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
