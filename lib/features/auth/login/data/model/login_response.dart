import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
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
}
