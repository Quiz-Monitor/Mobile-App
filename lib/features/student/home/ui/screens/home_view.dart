import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_cubit.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_state.dart';
import 'package:examify/features/student/home/ui/widgets/custom_home_appbar.dart';
import 'package:examify/features/student/home/ui/widgets/upcoming_exams_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white,
        ),
      ),
      child: SearchBar(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.w)),
        controller: _searchController,
        hintText: 'Search exams...',
        onChanged: (value) => setState(() => _searchQuery = value),
        leading: Icon(Icons.search_rounded, color: AppColors.white40),
        backgroundColor: WidgetStatePropertyAll(AppColors.white5),
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        shadowColor: WidgetStatePropertyAll(Colors.transparent),
        elevation: WidgetStatePropertyAll(0),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomHomeAppbar(),
            SizedBox(height: 20.h),
            _buildSearchBar(),
            SizedBox(height: 20.h),
            Text('Upcoming & Live Exams', style: AppTextStyles.white16w400),
            SizedBox(height: 16.h),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.mainBlue,
                onRefresh: () => context
                    .read<StudentExamCubit>()
                    .getUpcomingExams(showLoading: false),
                child: BlocBuilder<StudentExamCubit, StudentExamState>(
                  builder: (context, state) {
                    if (state is StudentExamInitial ||
                        state is StudentExamLoading) {
                      return Skeletonizer(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          itemCount: 5,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 10.h),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 100.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.white5,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    if (state is StudentExamFailure) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(height: 120.h),
                          _StateMessage(
                            icon: Icons.error_outline_rounded,
                            message: state.message,
                          ),
                        ],
                      );
                    }

                    if (state is StudentExamEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(height: 120.h),
                          const _StateMessage(
                            icon: Icons.event_available_rounded,
                            message:
                                'You have no live or upcoming exams right now.\nTake a break or review your history.',
                          ),
                        ],
                      );
                    }

                    final exams = (state as StudentExamSuccess).exams;

                    if (exams.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(height: 120.h),
                          const _StateMessage(
                            icon: Icons.event_available_rounded,
                            message:
                                'You have no live or upcoming exams right now.\nTake a break or review your history.',
                          ),
                        ],
                      );
                    }

                    final query = _searchQuery.trim().toLowerCase();
                    final filteredExams = query.isEmpty
                        ? exams
                        : exams.where((exam) {
                            final title = exam.examTitle.toLowerCase();
                            final code = exam.examCode.toLowerCase();
                            final instructor = exam.instructorName
                                .toLowerCase();
                            return title.contains(query) ||
                                code.contains(query) ||
                                instructor.contains(query);
                          }).toList();

                    if (filteredExams.isEmpty && query.isNotEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(height: 120.h),
                          const _StateMessage(
                            icon: Icons.search_off_rounded,
                            message: 'No exams found matching your search.',
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: filteredExams.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        return UpcomingExamsCard(
                          examModel: filteredExams[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({required this.message, this.icon});

  final String message;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 68.sp, color: AppColors.white40),
              SizedBox(height: 16.h),
            ],
            Text(
              message,
              style: AppTextStyles.white16w400.copyWith(
                color: AppColors.white60,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
