import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/core/themes/text_styles.dart';
import 'package:examify/core/widgets/custom_textfield.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_cubit.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_state.dart';
import 'package:examify/features/student/home/ui/widgets/custom_home_appbar.dart';
import 'package:examify/features/student/home/ui/widgets/upcoming_exams_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
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
            CustomTextfield(
              hintText: 'Search for exams',
              prefixIcon: Icon(
                Icons.search_rounded,
                color: AppColors.white40,
                size: 28,
              ),
            ),
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
                                isLive: true,
                                startTime: DateTime.now(),
                                endTime: DateTime.now(),
                                durationMinutes: 2,
                                questionCount: 2,
                                examStatus: '',
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
                          _StateMessage(
                            message: 'No upcoming exams yet.',
                          ),
                        ],
                      );
                    }

                    final exams = (state as StudentExamSuccess).exams;

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: exams.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        return UpcomingExamsCard(examModel: exams[index]);
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
