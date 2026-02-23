import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/routing/app_router.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/features/auth/onboarding/onboarding.dart';
import 'package:examify/core/themes/colors.dart';
import 'package:examify/features/role/logic/cubit/role_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => RoleCubit(),
          child: MaterialApp(
            theme: ThemeData(scaffoldBackgroundColor: AppColors.primaryBlack),
            onGenerateRoute: AppRouter().getapprouter,
            initialRoute: Routes.onboarding,
            debugShowCheckedModeBanner: false,
            home: const Onboarding(),
          ),
        );
      },
    );
  }
}
