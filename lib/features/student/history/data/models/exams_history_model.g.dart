// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exams_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamsHistoryModel _$ExamsHistoryModelFromJson(Map<String, dynamic> json) =>
    ExamsHistoryModel(
      finalScore: (json['finalScore'] as num?)?.toInt(),
      examTitle: json['examTitle'] as String,
      status: json['status'] as String,
      isPending: json['isPending'] as bool,
    );

Map<String, dynamic> _$ExamsHistoryModelToJson(ExamsHistoryModel instance) =>
    <String, dynamic>{
      'examTitle': instance.examTitle,
      'status': instance.status,
      'isPending': instance.isPending,
      'finalScore': instance.finalScore,
    };
