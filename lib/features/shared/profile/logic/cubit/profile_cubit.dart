import 'package:bloc/bloc.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/shared/profile/data/models/profile_user.dart';
import 'package:examify/features/shared/profile/data/repo/profile_repo.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(const ProfileInitial());

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
}
