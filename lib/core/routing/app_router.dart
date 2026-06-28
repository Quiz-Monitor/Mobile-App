import 'package:examify/core/routing/routes.dart';
import 'package:examify/core/widgets/main_navigation.dart';
import 'package:examify/features/auth/login/ui/screens/check_email_view.dart';
import 'package:examify/features/auth/login/ui/screens/login_view.dart';
import 'package:examify/features/auth/onboarding/onboarding.dart';
import 'package:examify/features/student/profile/ui/views/change_password_view.dart';
import 'package:examify/features/student/profile/ui/views/settings_view.dart';
import 'package:examify/features/auth/signup/ui/views/role_selection_view.dart';
import 'package:examify/features/auth/signup/ui/views/signup.dart';
import 'package:examify/features/auth/login/ui/screens/forgot_password.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_cubit.dart';
import 'package:examify/features/student/profile/ui/views/notifications_settings.dart';
import 'package:examify/features/student/home/ui/screens/home_view.dart';
import 'package:examify/core/di/service_locator.dart';
import 'package:examify/features/auth/signup/logic/cubit/signup_cubit.dart';
import 'package:examify/features/auth/login/logic/login_cubit.dart';
import 'package:examify/features/instructor/navigation/ui/views/instructor_navigation.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_cubit.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/create_exam_form_view.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/add_question_view.dart';
import 'package:examify/features/instructor/exam_creation/ui/views/manage_questions_view.dart';
import 'package:examify/features/instructor/grading/logic/cubit/grading_cubit.dart';
import 'package:examify/features/instructor/grading/ui/views/grading_view.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route<dynamic> getapprouter(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return CustomPageRoute(child: const Onboarding());
      case Routes.loginScreen:
        return CustomPageRoute(
          child: BlocProvider(
            create: (context) => getit<LoginCubit>(),
            child: const LoginView(),
          ),
        );
      case Routes.signupScreen:
        return CustomPageRoute(
          child: BlocProvider(
            create: (context) => getit<SignupCubit>(),
            child: const Signup(),
          ),
        );
      case Routes.roleSelectionScreen:
        return CustomPageRoute(child: const RoleSelectionView());
      case Routes.forgotPasswordScreen:
        return CustomPageRoute(child: const ForgotPassword());
      case Routes.checkEmailScreen:
        return CustomPageRoute(child: CheckEmailView());
      case Routes.changePasswordScreen:
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) => getit<ProfileCubit>(),
            child: const ChangePasswordView(),
          ),
        );
      case Routes.studentHomeScreen:
        return CustomPageRoute(child: const HomeView());
      case Routes.homeScreen:
        return CustomPageRoute(child: const MainNavigation());
      case Routes.instructorHomeScreen:
        return CustomPageRoute(child: const InstructorNavigation());
      case Routes.settingsScreen:
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) => getit<ProfileCubit>(),
            child: const SettingsView(),
          ),
        );
      case Routes.notificationsSettingsScreen:
        return CustomPageRoute(child: const NotificationsSettings());

      // New Feature Routes
      case Routes.createExamScreen:
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) => getit<ExamCreationCubit>(),
            child: const CreateExamFormView(),
          ),
        );
      case Routes.addQuestionScreen:
        final cubit = settings.arguments as ExamCreationCubit;
        return CustomPageRoute(
          child: BlocProvider.value(
            value: cubit,
            child: const AddQuestionView(),
          ),
        );
      case Routes.manageQuestionsScreen:
        final exam = settings.arguments as ExamModel;
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) =>
                getit<
                  ExamCreationCubit
                >(), // Note: assumes we want a fresh cubit here, unless we pass an existing one or it works fine.
            child: ManageQuestionsView(exam: exam),
          ),
        );
      case Routes.gradingScreen:
        final args = settings.arguments as Map<String, int>;
        return CustomPageRoute(
          child: BlocProvider(
            create: (_) =>
                getit<GradingCubit>()
                  ..loadAnswers(args['examId']!, args['studentId']!),
            child: GradingView(
              studentId: args['studentId']!,
              examId: args['examId']!,
            ),
          ),
        );

      default:
        return CustomPageRoute(
          child: const Scaffold(body: Center(child: Text('No route found'))),
        );
    }
  }
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;

  CustomPageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0.05, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                      reverseCurve: Curves.easeInCubic,
                    ),
                  ),
              child: child,
            ),
          );
        },
      );
}
