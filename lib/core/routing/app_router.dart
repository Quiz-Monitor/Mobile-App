import 'package:examify/features/login/ui/screens/login_view.dart';
import 'package:examify/features/onboarding/onboarding.dart';
import 'package:examify/features/signup/ui/views/role_selection_view.dart';
import 'package:examify/features/signup/ui/views/signup.dart';
import 'package:examify/features/login/ui/screens/forgot_password.dart';
import 'package:flutter/material.dart';

class AppRouter {
  MaterialPageRoute<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (context) => const Onboarding());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginView());
      case '/signup':
        return MaterialPageRoute(builder: (context) => const Signup());
      case '/roleSelection':
        return MaterialPageRoute(
          builder: (context) => const RoleSelectionView(),
        );
      case '/forgotPassword':
        return MaterialPageRoute(builder: (context) => const ForgotPassword());
      case '/resetPassword':
        return MaterialPageRoute(builder: (context) => const ForgotPassword());
      default:
        return MaterialPageRoute(
          builder: (context) => const Text('No route found'),
        );
    }
  }
}
