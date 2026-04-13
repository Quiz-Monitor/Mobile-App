import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/widgets/main_navigation.dart';
import 'package:examify/features/auth/login/ui/screens/check_email_view.dart';
import 'package:examify/features/auth/login/ui/screens/login_view.dart';
import 'package:examify/features/auth/onboarding/onboarding.dart';
import 'package:examify/features/student/profile/ui/views/change_password_view.dart';
import 'package:examify/features/student/profile/ui/views/settings_view.dart';
import 'package:examify/features/auth/signup/ui/views/role_selection_view.dart';
import 'package:examify/features/auth/signup/ui/views/signup.dart';
import 'package:examify/features/auth/login/ui/screens/forgot_password.dart';
import 'package:examify/features/student/profile/ui/views/notifications_settings.dart';
import 'package:examify/features/student/home/ui/screens/home_view.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/instructor/navigation/ui/views/instructor_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  MaterialPageRoute<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (context) => const Onboarding());
      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getit<LoginCubit>(),
            child: const LoginView(),
          ),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => getit<SignupCubit>(),
            child: const Signup(),
          ),
        );
      case Routes.roleSelectionScreen:
        return MaterialPageRoute(
          builder: (context) => const RoleSelectionView(),
        );
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(builder: (context) => const ForgotPassword());
      case Routes.checkEmailScreen:
        return MaterialPageRoute(builder: (context) => CheckEmailView());
      case Routes.changePasswordScreen:
        return MaterialPageRoute(
          builder: (context) => const ChangePasswordView(),
        );
      case Routes.studentHomeScreen:
        return MaterialPageRoute(builder: (context) => const HomeView());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const MainNavigation());
      case Routes.instructorHomeScreen:
        return MaterialPageRoute(
          builder: (context) => const InstructorNavigation(),
        );
      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (context) => const SettingsView());
      case Routes.notificationsSettingsScreen:
        return MaterialPageRoute(
          builder: (context) => const NotificationsSettings(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const Text('No route found'),
        );
    }
  }
}
