// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'written_answer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrittenAnswerModel _$WrittenAnswerModelFromJson(Map<String, dynamic> json) =>
    WrittenAnswerModel(
      answerId: (WrittenAnswerModel._readAnswerId(json, 'answerId') as num)
          .toInt(),
      questionText: json['questionText'] as String,
      studentAnswerText: json['studentAnswerText'] as String,
    );

Map<String, dynamic> _$WrittenAnswerModelToJson(WrittenAnswerModel instance) =>
    <String, dynamic>{
      'answerId': instance.answerId,
      'questionText': instance.questionText,
      'studentAnswerText': instance.studentAnswerText,
    };

GradeRequestBody _$GradeRequestBodyFromJson(Map<String, dynamic> json) =>
    GradeRequestBody(grade: (json['grade'] as num).toDouble());

Map<String, dynamic> _$GradeRequestBodyToJson(GradeRequestBody instance) =>
    <String, dynamic>{'grade': instance.grade};
