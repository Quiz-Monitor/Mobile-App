import 'package:dio/dio.dart';
import 'package:examify/core/config/cache/cache_helper.dart';
import 'package:examify/core/constants/api_constants.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/core/networking/dio_factory.dart';
import 'package:examify/core/storage/session_manager.dart';
import 'package:examify/core/storage/session_storage.dart';
import 'package:examify/features/auth/login/data/repo/login_repo.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/instructor/exams/data/repo/instructor_exams_repo.dart';
import 'package:examify/features/instructor/exams/logic/cubit/exams_cubit.dart';
import 'package:examify/features/instructor/home/data/repo/instructor_home_repo.dart';
import 'package:examify/features/shared/profile/data/repo/profile_repo.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_cubit.dart';
import 'package:examify/features/auth/signup/data/repo/signup_repo.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/student/join_exam/data/repo/join_exam_repo.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_cubit.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

Future<void> init() async {
  await CacheHelper.init();

  if (!getit.isRegistered<SessionStorage>()) {
    getit.registerLazySingleton<SessionStorage>(() => SecureSessionStorage());
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

  if (!getit.isRegistered<JoinExamRepo>()) {
    getit.registerLazySingleton<JoinExamRepo>(
      () => JoinExamRepo(getit.get<ApiService>()),
    );
  }
  if (!getit.isRegistered<JoinExamCubit>()) {
    getit.registerFactory<JoinExamCubit>(
      () => JoinExamCubit(getit.get<JoinExamRepo>()),
    );
  }

  if (!getit.isRegistered<InstructorExamsRepo>()) {
    getit.registerLazySingleton<InstructorExamsRepo>(
      () => InstructorExamsRepo(getit.get<ApiService>()),
    );
  }
  if (!getit.isRegistered<ExamsCubit>()) {
    getit.registerFactory<ExamsCubit>(
      () => ExamsCubit(getit.get<InstructorExamsRepo>()),
    );
  }
  if (!getit.isRegistered<InstructorHomeRepo>()) {
    getit.registerLazySingleton<InstructorHomeRepo>(
      () => InstructorHomeRepo(getit.get<InstructorExamsRepo>()),
    );
  }

  if (!getit.isRegistered<ProfileRepo>()) {
    getit.registerLazySingleton<ProfileRepo>(
      () => ProfileRepo(getit.get<ApiService>(), getit.get<SessionStorage>()),
    );
  }
  if (!getit.isRegistered<ProfileCubit>()) {
    getit.registerFactory<ProfileCubit>(
      () => ProfileCubit(getit.get<ProfileRepo>()),
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

  // if (!getit.isRegistered<InstructorReportsRepo>()) {
  //   getit.registerLazySingleton<InstructorReportsRepo>(
  //     () => InstructorReportsRepo(),
  //   );
  // }
}
