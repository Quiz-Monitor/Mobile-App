import 'package:examify/features/shared/profile/data/models/profile_user.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final ProfileUser profile;

  const ProfileSuccess(this.profile);
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
