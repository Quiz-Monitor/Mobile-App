import 'package:examify/app.dart';
import 'package:examify/core/config/cache/cache_constants.dart';
import 'package:examify/core/config/cache/cache_helper.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/services/notification_service.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  // Initialize local notifications for exam reminders
  await getit<NotificationService>().init();
  await getit<NotificationService>().requestPermissions();

  String? token = await CacheHelper.getAccessToken();
  String? role = CacheHelper.getString(CacheConstants.role);

  String initialRoute = Routes.onboarding;

  if (token != null && token.isNotEmpty) {
    if (role == 'student') {
      initialRoute = Routes.homeScreen; // Contains the bottom nav bar setup
    } else if (role == 'instructor') {
      initialRoute = Routes.instructorHomeScreen;
    }
  } 

  runApp(MyApp(initialRoute: initialRoute));
}
