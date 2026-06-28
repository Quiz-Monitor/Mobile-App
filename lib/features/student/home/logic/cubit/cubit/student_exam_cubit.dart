import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/services/notification_service.dart';
import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:examify/features/student/home/data/repo/student_upcoming_exams_repo.dart';

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
        final visibleExams = _filterVisibleExams(exams);

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
        emit(StudentExamFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }

  List<StudentExamModel> _filterVisibleExams(List<StudentExamModel> exams) {
    final now = DateTime.now();

    return exams.where((exam) {
      return exam.isLive || exam.startTime.isAfter(now);
    }).toList();
  }
}
