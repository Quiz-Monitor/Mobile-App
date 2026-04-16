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

  String getAllErrorMessages() {
    if (message != null && message!.isNotEmpty) {
      // Don't show generic defaultError if we can avoid it.
      if (message == 'defaultError' ||
          message == 'An unexpected error occurred. Please try again.') {
        return message!;
      }
      return message!;
    }
    if (errors != null && errors!.isNotEmpty) {
      return errors!.values.expand((element) => element).join('\n');
    }
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
