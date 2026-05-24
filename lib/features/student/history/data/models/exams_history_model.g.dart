// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsHistoryModel _$ExamsHistoryModelFromJson(Map<String, dynamic> json) =>
    ExamsHistoryModel(
      examTitle: json['examTitle'] as String,
      status: json['status'] as String,
      submitTime: json['submitTime'] as String?,
      finalScore: (json['finalScore'] as num?)?.toInt(),
      examTotalPoints: (json['examTotalPoints'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExamsHistoryModelToJson(ExamsHistoryModel instance) =>
    <String, dynamic>{
      'examTitle': instance.examTitle,
      'status': instance.status,
      'submitTime': instance.submitTime,
      'finalScore': instance.finalScore,
      'examTotalPoints': instance.examTotalPoints,
    };
