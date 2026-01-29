import 'package:examify/core/routing/app_router.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/features/onboarding/onboarding.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          //color: Colors.white,
          theme: ThemeData(scaffoldBackgroundColor: AppColors.primaryBlack),
          onGenerateRoute: AppRouter().getapprouter,
          initialRoute: Routes.onboarding,
          debugShowCheckedModeBanner: false,
          home: const Onboarding(),
        );
      },
    );
  }
}
