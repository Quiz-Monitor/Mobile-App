// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentExamModel _$StudentExamModelFromJson(Map<String, dynamic> json) =>
    StudentExamModel(
      examTitle: json['examTitle'] as String,
      instructorName: json['instructorName'] as String,
      examCode: json['examCode'] as String,
      isLive: json['isLive'] as bool,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      questionCount: (json['questionCount'] as num).toInt(),
      examStatus: json['examStatus'] as String,
    );

Map<String, dynamic> _$StudentExamModelToJson(StudentExamModel instance) =>
    <String, dynamic>{
      'examTitle': instance.examTitle,
      'instructorName': instance.instructorName,
      'examCode': instance.examCode,
      'isLive': instance.isLive,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'questionCount': instance.questionCount,
      'examStatus': instance.examStatus,
    };
