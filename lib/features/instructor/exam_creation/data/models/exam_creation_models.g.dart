// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_creation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateExamRequestBody _$CreateExamRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateExamRequestBody(
  title: json['title'] as String,
  description: json['description'] as String,
  durationMinutes: (json['durationMinutes'] as num).toInt(),
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  cameraRequired: json['cameraRequired'] as bool,
  tabSwitchingDetection: json['tabSwitchingDetection'] as bool,
  eyeTrackingEnabled: json['eyeTrackingEnabled'] as bool,
  multiplePersonDetection: json['multiplePersonDetection'] as bool,
  maxTabSwitches: (json['maxTabSwitches'] as num).toInt(),
  maxEyeAwaySeconds: (json['maxEyeAwaySeconds'] as num).toInt(),
);

Map<String, dynamic> _$CreateExamRequestBodyToJson(
  CreateExamRequestBody instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'durationMinutes': instance.durationMinutes,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'cameraRequired': instance.cameraRequired,
  'tabSwitchingDetection': instance.tabSwitchingDetection,
  'eyeTrackingEnabled': instance.eyeTrackingEnabled,
  'multiplePersonDetection': instance.multiplePersonDetection,
  'maxTabSwitches': instance.maxTabSwitches,
  'maxEyeAwaySeconds': instance.maxEyeAwaySeconds,
};

CreateExamResponse _$CreateExamResponseFromJson(Map<String, dynamic> json) =>
    CreateExamResponse(
      id: (CreateExamResponse._readId(json, 'id') as num).toInt(),
    );

Map<String, dynamic> _$CreateExamResponseToJson(CreateExamResponse instance) =>
    <String, dynamic>{'id': instance.id};

ChoiceDto _$ChoiceDtoFromJson(Map<String, dynamic> json) => ChoiceDto(
  choiceId: (json['choiceId'] as num?)?.toInt(),
  text: json['text'] as String,
  isCorrect: json['isCorrect'] as bool,
  orderNumber: (json['orderNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$ChoiceDtoToJson(ChoiceDto instance) => <String, dynamic>{
  'choiceId': instance.choiceId,
  'text': instance.text,
  'isCorrect': instance.isCorrect,
  'orderNumber': instance.orderNumber,
};

AddQuestionRequestBody _$AddQuestionRequestBodyFromJson(
  Map<String, dynamic> json,
) => AddQuestionRequestBody(
  text: json['questionText'] as String,
  type: json['questionType'] as String,
  points: (json['points'] as num).toInt(),
  orderNumber: (json['orderNumber'] as num).toInt(),
  choices: (json['choices'] as List<dynamic>)
      .map((e) => ChoiceDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AddQuestionRequestBodyToJson(
  AddQuestionRequestBody instance,
) => <String, dynamic>{
  'questionText': instance.text,
  'questionType': instance.type,
  'points': instance.points,
  'orderNumber': instance.orderNumber,
  'choices': instance.choices,
};

AddQuestionResponse _$AddQuestionResponseFromJson(Map<String, dynamic> json) =>
    AddQuestionResponse(questionId: (json['questionId'] as num).toInt());

Map<String, dynamic> _$AddQuestionResponseToJson(
  AddQuestionResponse instance,
) => <String, dynamic>{'questionId': instance.questionId};

QuestionLocalDto _$QuestionLocalDtoFromJson(Map<String, dynamic> json) =>
    QuestionLocalDto(
      id: (json['questionId'] as num?)?.toInt(),
      text: json['questionText'] as String,
      type: json['questionType'] as String,
      points: (json['points'] as num).toInt(),
      orderNumber:
          (QuestionLocalDto._readOrderNumber(json, 'orderNumber') as num?)
              ?.toInt(),
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ChoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionLocalDtoToJson(QuestionLocalDto instance) =>
    <String, dynamic>{
      'questionId': instance.id,
      'questionText': instance.text,
      'questionType': instance.type,
      'points': instance.points,
      'orderNumber': instance.orderNumber,
      'choices': instance.choices,
    };

ExamQuestionsWrapper _$ExamQuestionsWrapperFromJson(
  Map<String, dynamic> json,
) => ExamQuestionsWrapper(
  examId: (json['examId'] as num).toInt(),
  examTitle: json['examTitle'] as String,
  isPublished: json['isPublished'] as bool,
  totalQuestions: (json['totalQuestions'] as num).toInt(),
  questions: (json['questions'] as List<dynamic>)
      .map((e) => QuestionLocalDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ExamQuestionsWrapperToJson(
  ExamQuestionsWrapper instance,
) => <String, dynamic>{
  'examId': instance.examId,
  'examTitle': instance.examTitle,
  'isPublished': instance.isPublished,
  'totalQuestions': instance.totalQuestions,
  'questions': instance.questions,
};
