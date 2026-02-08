import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/widgets/main_navigation.dart';
import 'package:examify/features/login/ui/screens/check_email_view.dart';
import 'package:examify/features/login/ui/screens/login_view.dart';
import 'package:examify/features/onboarding/onboarding.dart';
import 'package:examify/features/profile/ui/views/change_password_view.dart';
import 'package:examify/features/profile/ui/views/settings_view.dart';
import 'package:examify/features/signup/ui/views/role_selection_view.dart';
import 'package:examify/features/signup/ui/views/signup.dart';
import 'package:examify/features/login/ui/screens/forgot_password.dart';
import 'package:flutter/material.dart';

class AppRouter {
  MaterialPageRoute<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return MaterialPageRoute(builder: (context) => const Onboarding());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (context) => const LoginView());
      case Routes.signupScreen:
        return MaterialPageRoute(builder: (context) => const Signup());
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
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (context) => const MainNavigation());
      case Routes.settingsScreen:
        return MaterialPageRoute(builder: (context) => const SettingsView());
      default:
        return MaterialPageRoute(
          builder: (context) => const Text('No route found'),
        );
    }
  }
}
