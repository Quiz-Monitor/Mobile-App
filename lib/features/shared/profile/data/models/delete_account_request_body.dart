import 'package:json_annotation/json_annotation.dart';

part 'delete_account_request_body.g.dart';

@JsonSerializable()
class DeleteAccountRequestBody {
  final String password;

  const DeleteAccountRequestBody({required this.password});

  factory DeleteAccountRequestBody.fromJson(Map<String, dynamic> json) =>
      _$DeleteAccountRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAccountRequestBodyToJson(this);
}
