import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/dio_factory.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/auth/signup/data/repo/signup_repo.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

Future<void> init() async {
  Dio dio = DioFactory.getDio();

  getit.registerLazySingleton<ApiService>(() => ApiService(dio));

  getit.registerLazySingleton<SignupRepo>(
    () => SignupRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<SignupCubit>(
    () => SignupCubit(getit.get<SignupRepo>()),
  );

  getit.registerLazySingleton<LoginRepo>(
    () => LoginRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<LoginCubit>(() => LoginCubit(getit.get<LoginRepo>()));
}
