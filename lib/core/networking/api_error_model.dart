import 'package:json_annotation/json_annotation.dart';
part 'api_error_model.g.dart';

@JsonSerializable()
class ApiErrorModel {
  final String? message;
  final int? code;
  final int? status;
  final String? title;
  final String? type;
  final String? traceId;
  final Map<String, List<String>>? errors;

  ApiErrorModel({
    this.message,
    this.code,
    this.status,
    this.title,
    this.type,
    this.traceId,
    this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);

  /// Returns a combined error message from [message], [title], or [errors].
  String getAllErrorMessages() {
    if (message != null && message!.isNotEmpty) {
      return message!;
    }
    if (errors != null && errors!.isNotEmpty) {
      return errors!.values.expand((element) => element).join('\n');
    }
    return title ?? 'Unknown error occurred';
  }
}
