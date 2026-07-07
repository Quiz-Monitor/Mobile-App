import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/services/notification_service.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/data/repo/student_upcoming_exams_repo.dart';
import 'package:flutter/foundation.dart';

import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_state.dart';

class StudentExamCubit extends Cubit<StudentExamState> {
  final StudentUpcomingExamsRepo _repo;
  final NotificationService _notificationService;

  StudentExamCubit(this._repo, this._notificationService)
    : super(const StudentExamInitial());

  Future<void> getUpcomingExams({bool showLoading = true}) async {
    if (showLoading) {
      emit(const StudentExamLoading());
    }

    final result = await _repo.getUpcomingExams();
    result.when(
      success: (exams) {
        try {
          debugPrint('[StudentExamCubit] Raw exams count: ${exams.length}');
          for (final e in exams) {
            debugPrint(
              '[StudentExamCubit] Exam: "${e.examTitle}" '
              'status="${e.examStatus}" isLive=${e.isLive} '
              'start=${e.startTime} end=${e.endTime}',
            );
          }

          final visibleExams = _filterVisibleExams(exams);
          debugPrint(
            '[StudentExamCubit] Visible exams count: ${visibleExams.length}',
          );

          // Schedule local notification reminders for upcoming exams
          _notificationService.cancelAllNotifications();
          _notificationService.scheduleExamNotifications(visibleExams);

          if (visibleExams.isEmpty) {
            emit(const StudentExamEmpty());
          } else {
            emit(StudentExamSuccess(visibleExams));
          }
        } catch (e, st) {
          debugPrint('[StudentExamCubit] Error parsing/sorting exams: $e\n$st');
          emit(StudentExamFailure('Failed to load exams: $e'));
        }
      },
      failure: (error) {
        debugPrint(
          '[StudentExamCubit] Failure: ${error.apiErrorModel.getAllErrorMessages()}',
        );
        emit(StudentExamFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }

  /// Filter exams strictly by time windows as requested.
  List<StudentExamModel> _filterVisibleExams(List<StudentExamModel> exams) {
    final now = DateTime.now();
    final visible = exams.where((exam) {
      final isUpcoming = exam.startTime.isAfter(now);
      return exam.isLive || isUpcoming;
    }).toList();

    // Sort: live exams first
    visible.sort((a, b) {
      if (a.isLive && !b.isLive) return -1;
      if (!a.isLive && b.isLive) return 1;

      // If both are live, sort by end time
      if (a.isLive && b.isLive) return a.endTime.compareTo(b.endTime);

      // If both are upcoming, sort by start time
      return a.startTime.compareTo(b.startTime);
    });

    return visible;
  }
}
