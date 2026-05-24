import 'package:freezed_annotation/freezed_annotation.dart';

part 'exams_history_model.g.dart';

@JsonSerializable()
class ExamsHistoryModel {
  final String examTitle;
  final String status;
  final String? submitTime;
  final int? finalScore;
  final int? examTotalPoints;

  ExamsHistoryModel({
    required this.examTitle,
    required this.status,
    this.submitTime,
    this.finalScore,
    this.examTotalPoints,
  });

  bool get isPending => status.toLowerCase() != 'graded';

  factory ExamsHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$ExamsHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamsHistoryModelToJson(this);
}
