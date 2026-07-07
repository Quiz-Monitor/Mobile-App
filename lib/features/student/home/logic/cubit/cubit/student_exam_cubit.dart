import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/services/notification_service.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/data/repo/student_upcoming_exams_repo.dart';
import 'package:flutter/foundation.dart';

import 'student_exam_state.dart';

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
      },
      failure: (error) {
        debugPrint(
          '[StudentExamCubit] Failure: ${error.apiErrorModel.getAllErrorMessages()}',
        );
        emit(StudentExamFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }

  /// Keep exams that are live OR haven't ended yet (upcoming / in-progress).
  /// The backend already returns only relevant student exams, so we only
  /// exclude exams that have already finished.
  List<StudentExamModel> _filterVisibleExams(List<StudentExamModel> exams) {
    final now = DateTime.now();

    return exams.where((exam) {
      // Show if exam is live, hasn't started yet, or hasn't ended yet
      return exam.isLive ||
          exam.startTime.isAfter(now) ||
          exam.endTime.isAfter(now);
    }).toList();
  }
}
