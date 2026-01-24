import 'package:examify/features/login/ui/screens/login_view.dart';
import 'package:examify/features/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class AppRouter {
  MaterialPageRoute<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (context) => const Onboarding());
      case '/login':
        return MaterialPageRoute(builder: (context) => const LoginView());
      // case '/studentHome':
      //   return MaterialPageRoute(
      //     builder: (context) => const StudentHomeScreen(),
      //   );
      default:
        return MaterialPageRoute(
          builder: (context) => const Text('No route found'),
        );
    }
  }
}
