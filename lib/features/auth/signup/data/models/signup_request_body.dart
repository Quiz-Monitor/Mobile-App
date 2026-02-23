import 'package:json_annotation/json_annotation.dart';

part 'signup_request_body.g.dart';

@JsonSerializable()
class SignupRequestBody {
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String? phoneNumber;

  SignupRequestBody({
    this.phoneNumber,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => _$SignupRequestBodyToJson(this);
}
