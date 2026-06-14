// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestBody _$ChangePasswordRequestBodyFromJson(
  Map<String, dynamic> json,
) => ChangePasswordRequestBody(
  currentPassword: json['currentPassword'] as String,
  newPassword: json['newPassword'] as String,
  confirmNewPassword: json['confirmNewPassword'] as String,
);

Map<String, dynamic> _$ChangePasswordRequestBodyToJson(
  ChangePasswordRequestBody instance,
) => <String, dynamic>{
  'currentPassword': instance.currentPassword,
  'newPassword': instance.newPassword,
  'confirmNewPassword': instance.confirmNewPassword,
};
