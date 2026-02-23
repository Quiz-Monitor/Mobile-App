import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_response.g.dart';

@JsonSerializable()
class SignupResponse {
  String userId;
  String email;
  String role;
  String createdAt;
  SignupResponse({
    required this.userId,
    required this.email,
    required this.role,
    required this.createdAt,
  });
  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);
}
