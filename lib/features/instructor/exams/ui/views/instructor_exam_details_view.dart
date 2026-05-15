import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/data/models/instructor_exam_result_model.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exams_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/matric_card.dart';
import 'package:examify/features/instructor/exams/ui/widgets/section%20_card.dart';
import 'package:examify/features/instructor/exams/ui/widgets/student_result_title.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      failure: (error) {
        throw Exception(
          error.apiErrorModel.message?.trim().isNotEmpty == true
              ? error.apiErrorModel.message
              : 'Failed to load exam results',
        );
      },
    );
  }

  Color _statusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized == 'clean') return const Color(0xff05DF72);
    if (normalized == 'suspected') return const Color(0xffF59E0B);
    if (normalized == 'confirmed') return const Color(0xffFF6B6B);
    return AppColors.white60;
  }

  List<Color> _scoreColor(double score) {
    if (score >= 85) {
      return [Color(0xff00C950).withAlpha(50), Color(0xff00BC7D).withAlpha(50)];
    }
    if (score >= 75) {
      return [Color(0xff2B7FFF).withAlpha(50), Color(0xff00B8DB).withAlpha(50)];
    }
    if (score >= 65) {
      return [Color(0xffF0B100).withAlpha(50), Color(0xffff6900).withAlpha(50)];
    }
    return const [Color(0xffFF6B6B)];
  }

  String _scoreLabel(double score) {
    if (score <= 20) return '0-20';
    if (score <= 40) return '21-40';
    if (score <= 60) return '41-60';
    if (score <= 80) return '61-80';
    return '81-100';
  }

  List<_ScoreBucket> _buildScoreBuckets(
    List<InstructorExamResultModel> results,
  ) {
    const labels = ['0-20', '21-40', '41-60', '61-80', '81-100'];
    final buckets = <String, int>{for (final label in labels) label: 0};

    for (final result in results) {
      buckets[_scoreLabel(result.finalScore)] =
          (buckets[_scoreLabel(result.finalScore)] ?? 0) + 1;
    }

    return labels
        .map((label) => _ScoreBucket(label: label, count: buckets[label] ?? 0))
        .toList();
  }

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return '${words.first.characters.first}${words[1].characters.first}'
        .toUpperCase();
  }

  void _exportResults(List<InstructorExamResultModel> results) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryBlack,
        content: Text('Exporting ${results.length} results...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<InstructorExamResultModel>>(
      future: _resultsFuture,
      builder: (context, snapshot) {
        final results = snapshot.data ?? const <InstructorExamResultModel>[];
        final hasResults = results.isNotEmpty;
        final totalStudents = results.length;
        final avgScore = totalStudents == 0
            ? 0.0
            : results.map((r) => r.finalScore).reduce((a, b) => a + b) /
                  totalStudents;
        final completed = totalStudents;
        final flags = results.fold<int>(
          0,
          (sum, row) => sum + row.totalViolations,
        );
        final scoreBuckets = _buildScoreBuckets(results);

        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton:
              snapshot.connectionState == ConnectionState.waiting || !hasResults
              ? null
              : FloatingActionButton.extended(
                  elevation: 6.0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  onPressed: () => _exportResults(results),
                  backgroundColor: AppColors.mainBlue,
                  foregroundColor: Colors.white,
                  label: Row(
                    children: [
                      SvgPicture.asset('assets/icons/download.svg'),
                      horizontalSpace(6.w),
                      Text(
                        'Export Results',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(widget.exam.title, style: AppTextStyles.white20),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
              child: (() {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: const Color(0xffFF6B6B),
                            size: 32.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Failed to load exam results',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white20.copyWith(
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${snapshot.error}'.replaceFirst('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white12w400alpha40.copyWith(
                              color: AppColors.white60,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => _resultsFuture = _loadResults()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (results.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: AppColors.white60,
                            size: 32.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'No results yet for this exam',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white20.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Students submissions will appear here when available.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.white12w400alpha40.copyWith(
                              color: AppColors.white60,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => _resultsFuture = _loadResults()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 50.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          horizontalSpace(34.w),
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14.sp,
                            color: AppColors.white60,
                          ),
                          horizontalSpace(6.w),
                          Text(
                            formatDate(widget.exam.startTime),
                            style: AppTextStyles.white12w400alpha40
                                .copyWith(color: Colors.white.withAlpha(150))
                                .copyWith(color: AppColors.white60),
                          ),
                          horizontalSpace(16.w),
                          Icon(
                            Icons.access_time_outlined,
                            size: 14.sp,
                            color: AppColors.white60,
                          ),
                          horizontalSpace(4.w),
                          Text(
                            '${widget.exam.durationMinutes} minutes',
                            style: AppTextStyles.white12w400alpha40.copyWith(
                              color: AppColors.white60,
                            ),
                          ),
                        ],
                      ),
                      verticalSpace(12.h),
                      Divider(color: AppColors.white10, thickness: 1.2.w),
                      verticalSpace(23.h),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12.w,
                        mainAxisSpacing: 12.h,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 152.5 / 139.4,
                        children: [
                          MetricCard(
                            iconPath: 'assets/icons/students_blue.svg',
                            iconColor: const Color(0xff00D3F3),
                            value: totalStudents.toString(),
                            label: 'Total Students',
                          ),
                          MetricCard(
                            iconPath: 'assets/icons/avg.svg',
                            iconColor: const Color(0xff00C950),
                            value: '${avgScore.toStringAsFixed(0)}%',
                            label: 'Avg Score',
                          ),
                          MetricCard(
                            iconPath: 'assets/icons/complete.svg',
                            iconColor: const Color(0xff3B82F6),
                            value: completed.toString(),
                            label: 'Completed',
                          ),
                          MetricCard(
                            iconPath: 'assets/icons/flags.svg',
                            iconColor: const Color(0xffEF4444),
                            value: flags.toString(),
                            label: 'Flags',
                          ),
                        ],
                      ),
                      verticalSpace(16.h),
                      SectionCard(
                        title: 'Score Distribution',
                        child: SizedBox(
                          height: 220.h,
                          child: Padding(
                            padding: EdgeInsets.only(top: 12.h),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: _BarDistributionChart(
                                          totalStudents: totalStudents,
                                          buckets: scoreBuckets,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: scoreBuckets
                                      .map(
                                        (bucket) => Expanded(
                                          child: Text(
                                            bucket.label,
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles
                                                .white12w400alpha40,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      verticalSpace(16.h),
                      SectionCard(
                        title: 'All Students ($totalStudents)',
                        trailing: SvgPicture.asset(
                          'assets/icons/students.svg',
                          width: 20.w,
                          colorFilter: ColorFilter.mode(
                            const Color(0xff00D3F3),
                            BlendMode.srcIn,
                          ),
                        ),
                        child: Column(
                          children: results
                              .map(
                                (row) => Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: StudentResultTile(
                                    row: row,
                                    backColors: _scoreColor(row.finalScore),
                                    statusColor: _statusColor(
                                      row.cheatingStatus,
                                    ),
                                    initials: _initials(row.studentName),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              })(),
            ),
          ),
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

class _BarDistributionChart extends StatelessWidget {
  const _BarDistributionChart({
    required this.totalStudents,
    required this.buckets,
  });

  final int totalStudents;
  final List<_ScoreBucket> buckets;

  @override
  Widget build(BuildContext context) {
    const maxY = 100.0;
    return SizedBox(
      height: 150.h,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          barGroups: List.generate(buckets.length, (i) {
            final percent = totalStudents == 0
                ? 0.0
                : (buckets[i].count / totalStudents) * 100;
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: percent,
                  color: AppColors.mainBlue,
                  width: 16.w,
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 36),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.w,
                interval: 25,
                getTitlesWidget: (value, meta) {
                  const allowed = [0.0, 25.0, 50.0, 75.0, 100.0];
                  if (!allowed.contains(value)) {
                    return const SizedBox.shrink();
                  }

                  return Text(
                    value.toInt().toString(),
                    style: AppTextStyles.white12w400alpha40,
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 25,
          ),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: true),
        ),
      ),
    );
  }
}
