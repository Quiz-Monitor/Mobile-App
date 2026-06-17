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
import 'package:examify/features/instructor/home/logic/cubit/instructor_home_cubit.dart';
import 'package:examify/features/shared/profile/data/repo/profile_repo.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_cubit.dart';
import 'package:examify/features/auth/signup/data/repo/signup_repo.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/student/join_exam/data/repo/join_exam_repo.dart';
import 'package:examify/features/student/join_exam/logic/join_exam_cubit.dart';
import 'package:examify/features/student/history/data/repo/student_history_repo.dart';
import 'package:examify/features/student/history/logic/cubit/student_results_cubit.dart';
import 'package:examify/features/student/home/data/repo/student_upcoming_exams_repo.dart';
import 'package:examify/features/student/home/logic/cubit/cubit/student_exam_cubit.dart';
import 'package:get_it/get_it.dart';

final getit = GetIt.instance;

Future<void> init() async {
  await CacheHelper.init();

  getit.registerLazySingleton<SessionStorage>(() => SecureSessionStorage());
  getit.registerLazySingleton<SessionManager>(
    () => SessionManager(getit<SessionStorage>()),
  );

  DioFactory.initSessionStorage(getit<SessionStorage>());
  Dio dio = DioFactory.getDio();

  getit.registerLazySingleton<ApiService>(
    () => ApiService(dio, baseUrl: ApiConstants.runtimeApiBaseUrl),
  );

  getit.registerLazySingleton<SignupRepo>(
    () => SignupRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<SignupCubit>(
    () => SignupCubit(getit.get<SignupRepo>(), getit.get<SessionStorage>()),
  );

  getit.registerLazySingleton<LoginRepo>(
    () => LoginRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<LoginCubit>(
    () => LoginCubit(getit.get<LoginRepo>(), getit.get<SessionStorage>()),
  );

  getit.registerLazySingleton<JoinExamRepo>(
    () => JoinExamRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<JoinExamCubit>(
    () => JoinExamCubit(getit.get<JoinExamRepo>()),
  );

  getit.registerLazySingleton<StudentUpcomingExamsRepo>(
    () => StudentUpcomingExamsRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<StudentExamCubit>(
    () => StudentExamCubit(getit.get<StudentUpcomingExamsRepo>()),
  );

  getit.registerLazySingleton<InstructorExamsRepo>(
    () => InstructorExamsRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<ExamsCubit>(
    () => ExamsCubit(getit.get<InstructorExamsRepo>()),
  );

  getit.registerLazySingleton<InstructorHomeRepo>(
    () => InstructorHomeRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<InstructorHomeCubit>(
    () => InstructorHomeCubit(getit.get<InstructorHomeRepo>()),
  );

  getit.registerLazySingleton<ProfileRepo>(
    () => ProfileRepo(getit.get<ApiService>(), getit.get<SessionStorage>()),
  );
  getit.registerFactory<ProfileCubit>(
    () => ProfileCubit(getit.get<ProfileRepo>(), getit.get<SessionManager>()),
  );

  getit.registerLazySingleton<StudentHistoryRepo>(
    () => StudentHistoryRepo(getit.get<ApiService>()),
  );
  getit.registerFactory<StudentResultsCubit>(
    () => StudentResultsCubit(getit.get<StudentHistoryRepo>()),
  );
}
