import 'package:examify/features/onboarding/onboarding.dart';
import 'package:flutter/material.dart';

class AppRouter {
  MaterialPageRoute<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return MaterialPageRoute(builder: (context) => const Onboarding());
      // case '/login':
      //   return MaterialPageRoute(builder: (context) => const LoginScreen());
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
