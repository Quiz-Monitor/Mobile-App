import 'package:freezed_annotation/freezed_annotation.dart';


part 'exams_history_model.g.dart';
@JsonSerializable()
class ExamsHistoryModel {
  final String examTitle;
  final String status;
  final bool isPending;
  final int? finalScore;

  ExamsHistoryModel({
    required this.finalScore,
    required this.examTitle,
    required this.status,
    required this.isPending,
  });
  factory ExamsHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExamsHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamsHistoryModelToJson(this);
}