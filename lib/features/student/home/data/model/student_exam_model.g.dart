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
      examStatus: json['examStatus'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      questionCount: (json['questionCount'] as num).toInt(),
    );

Map<String, dynamic> _$StudentExamModelToJson(StudentExamModel instance) =>
    <String, dynamic>{
      'examTitle': instance.examTitle,
      'instructorName': instance.instructorName,
      'examCode': instance.examCode,
      'examStatus': instance.examStatus,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'questionCount': instance.questionCount,
    };
