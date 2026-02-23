
import 'package:examify/features/role/domain/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_state.freezed.dart';

@freezed
class SignupState with _$SignupState {
  const factory SignupState.initial() = Initial;
  const factory SignupState.loading() = Loading;
  const factory SignupState.success({required UserRole role}) = SignupSuccess;
  const factory SignupState.error({required String error}) = SignupFailure;
}
