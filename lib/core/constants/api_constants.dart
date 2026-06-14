import 'package:flutter/foundation.dart';

class ApiConstants {
  // APP_ENV values: dev | staging | prod
  static const String _appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = _appEnv == 'prod'
      ? 'https://api.examify.com/'
      : _appEnv == 'staging'
      ? 'https://staging-api.examify.com/'
      : 'https://10.0.2.2:7158/';

  /// Runtime base URL used by the app.
  ///
  /// Android emulator uses `10.0.2.2`, while desktop and web should use
  /// `localhost` to reach the API running on the development machine.
  static String get runtimeApiBaseUrl {
    if (_appEnv == 'prod') {
      return 'https://api.examify.com/';
    }

    if (_appEnv == 'staging') {
      return 'https://staging-api.examify.com/';
    }

    if (kIsWeb) {
      return 'https://localhost:7158/';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'https://10.0.2.2:7158/';
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        return 'https://localhost:7158/';
    }
  }

  static const String login = "api/auth/login"; // ✅ done
  static const String signup = "api/auth/register"; // ✅ done
  static const String refreshToken = "api/auth/refresh"; // ✅ done
  static const String logout = "/api/auth/logout"; // ✅ done
  static const String changePassword = "/api/auth/change-password"; // in progress...

  //static const String forgotPassword = "api/auth/forgot-password"; 

  // Student endpoints placeholders
  static const String studentResult = "api/students/me/results";
  static const String studentExamJoin = "api/exams/join"; // ✅ done
  static const String studentUpcomingExams = "/api/students/me/exams"; // ✅ done
  static const String studentExamHistory = "/api/students/me/results"; // ✅ done

  // User profile endpoint
  static const String userProfile = "api/users/me"; // ✅ done
  static const String deleteAccout = "/api/auth/delete-account"; // in progress...

  // Instructor endpoints placeholders
  static const String getInstructorExams = "api/exams"; // ✅ done

  // Shared placeholders
  // static const String notifications = "api/notifications";
}
