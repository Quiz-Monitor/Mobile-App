import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/storage/session_manager.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';
import 'package:examify/features/shared/profile/data/repo/profile_repo.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;
  final SessionManager _sessionManager;

  ProfileCubit(this._profileRepo, this._sessionManager)
    : super(const ProfileInitial());

  Future<void> getProfile({bool showLoading = true}) async {
    if (showLoading) {
      emit(const ProfileLoading());
    }

    final ApiResult<ProfileUser> result = await _profileRepo.getProfile();

    result.when(
      success: (profile) {
        emit(ProfileSuccess(profile));
      },
      failure: (error) {
        emit(ProfileFailure(error.apiErrorModel.getAllErrorMessages()));
      },
    );
  }

  Future<void> logout() async {
    await _sessionManager.logout();
    emit(const ProfileLoggedOut());
  }
}
