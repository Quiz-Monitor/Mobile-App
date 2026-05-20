import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
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
        hintText: 'Search for exams',
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
            Text('Upcoming Exams', style: AppTextStyles.white16w400),
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
                            return UpcomingExamsCard(
                              examModel: StudentExamModel(
                                examTitle: 'examTitle',
                                instructorName: 'instructorName',
                                examCode: 'examCode',
                                examStatus: 'Live',
                                startTime: DateTime.now(),
                                endTime: DateTime.now(),
                                durationMinutes: 2,
                                questionCount: 2,
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
                          _StateMessage(message: state.message),
                        ],
                      );
                    }

                    if (state is StudentExamEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: const [
                          SizedBox(height: 120),
                          _StateMessage(message: 'No upcoming exams yet.'),
                        ],
                      );
                    }

                    final exams = (state as StudentExamSuccess).exams;
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
                        children: const [
                          SizedBox(height: 120),
                          _StateMessage(message: 'No matching exams found.'),
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
  const _StateMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.white16w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
