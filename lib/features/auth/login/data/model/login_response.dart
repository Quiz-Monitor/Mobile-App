import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

Object? readToken(Map map, String key) {
  return map['accessToken'] ?? map['token'];
}

@JsonSerializable()
class LoginResponse {
  @JsonKey(readValue: readToken)
  final String? token;
  final String? message;
  final String? refreshToken;
  final String? expiresAt;
  final User? user;

  LoginResponse({
    this.token,
    this.message,
    this.refreshToken,
    this.expiresAt,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  factory LoginResponse.fromNullableJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LoginResponse.empty();
    }
    return LoginResponse.fromJson(json);
  }

  const LoginResponse.empty()
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
