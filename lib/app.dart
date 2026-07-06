import 'package:examify/core/routing/app_router.dart';
import 'package:examify/core/themes/app_colors.dart';
import 'package:examify/features/role/logic/cubit/role_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:toastification/toastification.dart';

class MyApp extends StatelessWidget {
  final String initialRoute;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => RoleCubit(),
          child: ToastificationWrapper(
            child: MaterialApp(
              useInheritedMediaQuery: true,
              locale: DevicePreview.locale(context),
              builder: DevicePreview.appBuilder,
              navigatorKey: navigatorKey,
              theme: ThemeData(scaffoldBackgroundColor: AppColors.primaryBlack),
              onGenerateRoute: AppRouter().getapprouter,
              initialRoute: initialRoute,
              debugShowCheckedModeBanner: false,
            ),
          ),
        );
      },
    );
  }
}
