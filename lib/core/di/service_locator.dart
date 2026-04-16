import 'package:dio/dio.dart';
import 'package:examify/core/constants/api_constants.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/dio_factory.dart';
import 'package:examify/core/storage/session_manager.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/auth/signup/data/repo/signup_repo.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/home/data/repo/instructor_home_repo.dart';
import 'package:examify/features/instructor/reports/data/repo/instructor_reports_repo.dart';
import 'package:examify/features/student/history/data/repos/student_history_repo.dart';
import 'package:examify/features/student/home/data/repo/student_home_repo.dart';
import 'package:examify/features/student/profile/data/repo/student_profile_repo.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

Future<void> init() async {
  if (!getit.isRegistered<SessionStorage>()) {
    getit.registerLazySingleton<SessionStorage>(() => InMemorySessionStorage());
  }
  if (!getit.isRegistered<SessionManager>()) {
    getit.registerLazySingleton<SessionManager>(
      () => SessionManager(getit<SessionStorage>()),
    );
  }

  DioFactory.initSessionStorage(getit<SessionStorage>());
  Dio dio = DioFactory.getDio();

  if (!getit.isRegistered<ApiService>()) {
    getit.registerLazySingleton<ApiService>(
      () => ApiService(dio, baseUrl: ApiConstants.runtimeApiBaseUrl),
    );
  }

  if (!getit.isRegistered<SignupRepo>()) {
    getit.registerLazySingleton<SignupRepo>(
      () => SignupRepo(getit.get<ApiService>()),
    );
  }
  if (!getit.isRegistered<SignupCubit>()) {
    getit.registerFactory<SignupCubit>(
      () => SignupCubit(getit.get<SignupRepo>(), getit.get<SessionStorage>()),
    );
  }

  if (!getit.isRegistered<LoginRepo>()) {
    getit.registerLazySingleton<LoginRepo>(
      () => LoginRepo(getit.get<ApiService>()),
    );
  }
  if (!getit.isRegistered<LoginCubit>()) {
    getit.registerFactory<LoginCubit>(
      () => LoginCubit(getit.get<LoginRepo>(), getit.get<SessionStorage>()),
    );
  }

  // if (!getit.isRegistered<StudentHomeRepo>()) {
  //   getit.registerLazySingleton<StudentHomeRepo>(() => StudentHomeRepo());
  // }
  // if (!getit.isRegistered<StudentHistoryRepo>()) {
  //   getit.registerLazySingleton<StudentHistoryRepo>(() => StudentHistoryRepo());
  // }
  // if (!getit.isRegistered<StudentProfileRepo>()) {
  //   getit.registerLazySingleton<StudentProfileRepo>(() => StudentProfileRepo());
  // }

  // if (!getit.isRegistered<InstructorHomeRepo>()) {
  //   getit.registerLazySingleton<InstructorHomeRepo>(() => InstructorHomeRepo());
  // }
  // if (!getit.isRegistered<InstructorExamsRepo>()) {
  //   getit.registerLazySingleton<InstructorExamsRepo>(
  //     () => InstructorExamsRepo(),
  //   );
  // }
  // if (!getit.isRegistered<InstructorReportsRepo>()) {
  //   getit.registerLazySingleton<InstructorReportsRepo>(
  //     () => InstructorReportsRepo(),
  //   );
  // }
}
