class ApiConstants {
  static const String apiBaseUrl =
      'https://quizmonitor-api-production.up.railway.app/';

  /// Runtime base URL used by the app.
  static String get runtimeApiBaseUrl => apiBaseUrl;

  static const String login = "api/auth/login"; // ✅ done
  static const String signup = "api/auth/register"; // ✅ done
  static const String refreshToken = "api/auth/refresh"; // ✅ done
  static const String logout = "/api/auth/logout"; // ✅ done
  static const String changePassword = "/api/auth/change-password"; // ✅ done

  //static const String forgotPassword = "api/auth/forgot-password"; // in progress...

  // Student endpoints placeholders
  static const String studentResult = "api/students/me/results"; // ✅ done
  static const String studentStats = "/api/students/me/statistics"; // ✅ done
  static const String studentExamJoin = "api/exams/join"; // ✅ done
  static const String studentUpcomingExams = "/api/students/me/exams"; // ✅ done
  static const String studentExamHistory = "/api/students/me/results"; // ✅ done

  // User profile endpoint
  static const String userProfile = "api/users/me"; // ✅ done
  static const String deleteAccount = "/api/auth/delete-account"; // ✅ done

  // Instructor endpoints placeholders
  static const String getInstructorProfile =
      "/api/instructors/me/statistics"; // ✅ done
  static const String getInstructorExams = "api/exams"; // ✅ done
  static const String createExam = "api/exams"; // ✅ done
  static const String addExamQuestion = "api/exams/{examId}/questions";
  static const String updateExamQuestion =
      "api/exams/{examId}/questions/{questionId}"; // ✅ done
  static const String getExamQuestions =
      "api/exams/{examId}/questions"; // ✅ done
  static const String deleteExamQuestion =
      "api/exams/{examId}/questions/{questionId}"; // ✅ done
  static const String publishExam = "api/exams/{examId}/publish"; // ✅ done
  static const String deleteExam = "api/exams/{examId}"; // ✅ done
  static const String updateExam = "api/exams/{examId}"; // ✅ done
  static const String getWrittenAnswers =
      "api/exams/{examId}/students/{studentId}/written-answers";
  static const String gradeAnswer = "api/answers/{answerId}/grade";

  // Shared placeholders
  // static const String notifications = "api/notifications";
}
