import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/helpers/spacing.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/app_text_styles.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_cubit.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_state.dart';
import 'package:examify/features/instructor/exams/ui/views/instructor_exam_details_view.dart';
import 'package:examify/features/instructor/exams/ui/widgets/instructor_exam_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InstructorExamsView extends StatefulWidget {
  const InstructorExamsView({super.key});

  @override
  State<InstructorExamsView> createState() => _InstructorExamsViewState();
}

class _InstructorExamsViewState extends State<InstructorExamsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  ExamFilter _selectedFilter = ExamFilter.all;

  Future<void> _refreshExams(BuildContext context) async {
    await context.read<ExamsCubit>().getInstructorExams(showLoading: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filterExams(List<dynamic> exams) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return exams;

    return exams.where((exam) {
      final title = exam.title.toString().toLowerCase();
      final code = exam.examCode.toString().toLowerCase();
      final description = exam.description.toString().toLowerCase();
      return title.contains(query) ||
          code.contains(query) ||
          description.contains(query);
    }).toList();
  }

  List<dynamic> _applyExamFilter(List<dynamic> exams) {
    return exams.where((exam) {
      switch (_selectedFilter) {
        case ExamFilter.all:
          return true;
        case ExamFilter.live:
          return exam.isLive == true;
        case ExamFilter.upcoming:
          return exam.isUpcoming == true;
        case ExamFilter.completed:
          return exam.isCompleted == true;
      }
    }).toList();
  }

  // date formatting moved to top-level function `formatDate` below

  Widget _buildSkeletonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructor Exams', style: AppTextStyles.white20),
        SizedBox(height: 16.h),
        Expanded(
          child: Skeletonizer(
            enabled: true,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(8),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white.withAlpha(18)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Advanced Physics Midterm Exam',
                              style: AppTextStyles.white20,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff00D3F3).withAlpha(40),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'Scheduled',
                              style: TextStyle(
                                color: const Color(0xff00D3F3),
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Exam description placeholder for loading skeleton state.',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Code: PHYS2026',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Starts: Apr 23, 11:30 AM',
                        style: AppTextStyles.white12w400alpha40,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
          ),
        ),
        child: SearchBar(
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16.w),
          ),
          controller: _searchController,
          hintText: 'Search exams...',
          onChanged: (value) => setState(() => _searchQuery = value),
          leading: Icon(Icons.search_rounded, color: AppColors.white40),
          backgroundColor: WidgetStatePropertyAll(AppColors.white5),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: AppColors.white10, width: 1.74.w),
          ),
          textStyle: WidgetStatePropertyAll(AppTextStyles.white16w400),
          hintStyle: WidgetStatePropertyAll(
            AppTextStyles.white16w400.copyWith(color: AppColors.white40),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required ExamFilter filter,
  }) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = filter),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.mainBlue : AppColors.white5,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.mainBlue : AppColors.white10,
            width: 1.74.w,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.white60,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit<ExamsCubit>()..getInstructorExams(),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: BlocBuilder<ExamsCubit, ExamsState>(
            builder: (context, state) {
              if (state is ExamsInitial || state is ExamsLoading) {
                return _buildSkeletonList();
              }

              if (state is ExamsFailure) {
                return RefreshIndicator(
                  color: AppColors.mainBlue,
                  onRefresh: () => _refreshExams(context),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      SizedBox(height: 140.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Center(
                          child: Text(
                            state.message,
                            style: AppTextStyles.white20,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final successState = state as ExamsSuccess;
              final exams = successState.exams;
              final enrolledCounts = successState.enrolledCounts;
              final searchedExams = _filterExams(exams);
              final filteredExams = _applyExamFilter(searchedExams);
              final liveCount = exams
                  .where((exam) => exam.isLive == true)
                  .length;
              final upcomingCount = exams
                  .where((exam) => exam.isUpcoming == true)
                  .length;
              final completedCount = exams
                  .where((exam) => exam.isCompleted == true)
                  .length;

              if (exams.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => _refreshExams(context),
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
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Exams', style: AppTextStyles.white20),
                  _buildSearchBar(),
                  SizedBox(height: 18.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          count: exams.length,
                          filter: ExamFilter.all,
                        ),
                        horizontalSpace(14.w),
                        _buildFilterChip(
                          label: 'Live',
                          count: liveCount,
                          filter: ExamFilter.live,
                        ),
                        horizontalSpace(14.w),
                        _buildFilterChip(
                          label: 'Upcoming',
                          count: upcomingCount,
                          filter: ExamFilter.upcoming,
                        ),
                        horizontalSpace(14.w),
                        _buildFilterChip(
                          label: 'Completed',
                          count: completedCount,
                          filter: ExamFilter.completed,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Divider(color: AppColors.white10, thickness: 1.74.w),
                  verticalSpace(12.h),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryBlack,
                      onRefresh: () => _refreshExams(context),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemCount: filteredExams.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final exam = filteredExams[index];
                          final isLive = exam.isLive;
                          final isCompleted = exam.isCompleted;
                          final enrolledCount =
                              enrolledCounts[exam.examId] ?? 0;

                          return InstructorExamCard(
                            exam: exam,
                            isLive: isLive,
                            isCompleted: isCompleted,
                            enrolledCount: enrolledCount,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      InstructorExamDetailsView(exam: exam),
                                ),
                              );
                            },
                          );
                        },
                      ),
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

enum ExamFilter { all, live, upcoming, completed }

class ExamCardState extends StatelessWidget {
  const ExamCardState({
    super.key,
    required this.isLive,
    required this.isCompleted,
  });

  final dynamic isLive;
  final dynamic isCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? const Color(0xffAD46FF).withAlpha(50)
            : isLive
            ? const Color(0xff00C950).withAlpha(50)
            : const Color(0xff2B7FFF).withAlpha(50),
        border: Border.all(
          color: isCompleted
              ? const Color(0xffA855F7).withAlpha(75)
              : isLive
              ? const Color(0xff00C950).withAlpha(75)
              : const Color(0xff2B7FFF).withAlpha(75),
          width: 1.74.w,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: isCompleted
          ? Text(
              'Completed',
              style: TextStyle(
                color: const Color(0xffC084FC),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          : isLive
          ? Row(
              children: [
                Icon(Icons.circle, size: 6, color: const Color(0xff05DF72)),
                horizontalSpace(4.w),
                Text(
                  'Live',
                  style: TextStyle(
                    color: const Color(0xff05DF72),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          : Text(
              'Upcoming',
              style: TextStyle(
                color: const Color(0xff51A2FF),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

String formatDate(DateTime time) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final minute = time.minute.toString().padLeft(2, '0');
  final suffix = time.hour >= 12 ? 'PM' : 'AM';
  return '${months[time.month - 1]} ${time.day}, $hour:$minute $suffix';
}
