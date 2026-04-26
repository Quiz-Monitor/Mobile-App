import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/routing/routes.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_cubit.dart';
import 'package:examify/features/shared/profile/logic/cubit/profile_state.dart';
import 'package:examify/features/shared/profile/ui/widgets/profile_page_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InstructorProfileView extends StatelessWidget {
  const InstructorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit<ProfileCubit>()..getProfile(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileFailure) {
            return _ProfileErrorView(
              message: state.message,
              onRetry: () {
                context.read<ProfileCubit>().getProfile();
              },
            );
          }

          if (state is ProfileSuccess) {
            return ProfilePageBody(
              profile: state.profile,
              onSettingsTap: () {
                Navigator.pushNamed(context, Routes.settingsScreen);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProfileErrorView extends StatelessWidget {
  const _ProfileErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
