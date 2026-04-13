
import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_state.freezed.dart';

@freezed
class SignupState<T> with _$SignupState {
  const factory SignupState.initial() = Initial;
  const factory SignupState.loading() = Loading;
  const factory SignupState.success(T data) = SignupSuccess<T>;
  const factory SignupState.failure({required String error}) = SignupFailure;
}
