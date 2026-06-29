// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => _ExamModel(
  examId: (json['examId'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  startTime: const LocalDateTimeConverter().fromJson(
    json['startTime'] as String,
  ),
  endTime: const LocalDateTimeConverter().fromJson(json['endTime'] as String),
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  examCode: json['examCode'] as String,
  instructorName: json['instructorName'] as String? ?? '',
  isPublished: json['isPublished'] as bool? ?? false,
);

Map<String, dynamic> _$ExamModelToJson(_ExamModel instance) =>
    <String, dynamic>{
      'examId': instance.examId,
      'title': instance.title,
      'description': instance.description,
      'startTime': const LocalDateTimeConverter().toJson(instance.startTime),
      'endTime': const LocalDateTimeConverter().toJson(instance.endTime),
      'durationMinutes': instance.durationMinutes,
      'examCode': instance.examCode,
      'instructorName': instance.instructorName,
      'isPublished': instance.isPublished,
    };
