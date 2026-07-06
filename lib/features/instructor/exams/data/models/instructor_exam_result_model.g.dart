// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_exam_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorExamResultModel _$InstructorExamResultModelFromJson(
  Map<String, dynamic> json,
) => InstructorExamResultModel(
  studentId: json['studentId'] as int,
  studentName: json['studentName'] as String,
  finalScore: (json['finalScore'] as num).toDouble(),
  cheatingStatus: json['cheatingStatus'] as String,
  totalViolations: json['totalViolations'] as int,
);

Map<String, dynamic> _$InstructorExamResultModelToJson(
  InstructorExamResultModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'studentName': instance.studentName,
  'finalScore': instance.finalScore,
  'cheatingStatus': instance.cheatingStatus,
  'totalViolations': instance.totalViolations,
};
