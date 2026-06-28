import 'package:freezed_annotation/freezed_annotation.dart';
part 'signup_response.g.dart';

@JsonSerializable()
class SignupResponse {
  final String? token;
  final String? message;
  final String? refreshToken;
  final String? expiresAt;
  final User? user;

  SignupResponse({
    this.token,
    this.message,
    this.refreshToken,
    this.expiresAt,
    this.user,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignupResponseToJson(this);

  factory SignupResponse.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SignupResponse.empty();
    }
    return SignupResponse.fromJson(json);
  }

  const SignupResponse.empty()
    : token = null,
      message = null,
      refreshToken = null,
      expiresAt = null,
      user = null;
}

@JsonSerializable()
class User {
  final int? userId;
  final String? email;
  final String? fullName;
  final String? role;
  final String? phoneNumber;
  final String? profilePicture;
  final String? lastLogin;
  final String? createdAt;

  User({
    this.userId,
    this.email,
    this.fullName,
    this.role,
    this.phoneNumber,
    this.profilePicture,
    this.lastLogin,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const User.empty();
    }
    return User.fromJson(json);
  }

  const User.empty()
    : userId = null,
      email = null,
      fullName = null,
      role = null,
      phoneNumber = null,
      profilePicture = null,
      lastLogin = null,
      createdAt = null;
}
