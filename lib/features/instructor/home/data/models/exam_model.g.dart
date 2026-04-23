// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => ExamModel(
  examId: (json['examId'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  endTime: DateTime.parse(json['endTime'] as String),
  durationMinutes: json['durationMinutes'] as String,
  examCode: json['examCode'] as String,
);

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
  'examId': instance.examId,
  'title': instance.title,
  'description': instance.description,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
  'examCode': instance.examCode,
};
