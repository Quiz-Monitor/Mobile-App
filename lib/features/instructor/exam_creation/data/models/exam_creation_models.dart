import 'package:json_annotation/json_annotation.dart';

part 'exam_creation_models.g.dart';

@JsonSerializable()
class CreateExamRequestBody {
  final String title;
  final String description;
  final int durationMinutes;
  final String startTime;
  final String endTime;
  final bool cameraRequired;
  final bool tabSwitchingDetection;
  final bool eyeTrackingEnabled;
  final bool multiplePersonDetection;
  final int maxTabSwitches;
  final int maxEyeAwaySeconds;

  CreateExamRequestBody({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.startTime,
    required this.endTime,
    required this.cameraRequired,
    required this.tabSwitchingDetection,
    required this.eyeTrackingEnabled,
    required this.multiplePersonDetection,
    required this.maxTabSwitches,
    required this.maxEyeAwaySeconds,
  });

  factory CreateExamRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CreateExamRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CreateExamRequestBodyToJson(this);
}

@JsonSerializable()
class CreateExamResponse {
  @JsonKey(name: 'id', readValue: _readId)
  final int id;

  CreateExamResponse({required this.id});

  factory CreateExamResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateExamResponseFromJson(json);

  // Safely extract 'id' or 'examId'
  static dynamic _readId(Map map, String key) {
    return map['id'] ?? map['examId'] ?? map['exam_id'] ?? 0;
  }
}

@JsonSerializable()
class ChoiceDto {
  final int? choiceId;
  final String text;
  final bool isCorrect;
  final int? orderNumber;

  ChoiceDto({
    this.choiceId,
    required this.text,
    required this.isCorrect,
    this.orderNumber,
  });

  factory ChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$ChoiceDtoFromJson(json);

  /// Custom toJson that omits null fields so the API doesn't reject the request
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'text': text, 'isCorrect': isCorrect};
    if (choiceId != null) map['choiceId'] = choiceId;
    if (orderNumber != null) map['orderNumber'] = orderNumber;
    return map;
  }
}

@JsonSerializable()
class AddQuestionRequestBody {
  @JsonKey(name: 'questionText')
  final String text;

  @JsonKey(name: 'questionType')
  final String type;

  final int points;
  final int orderNumber;
  final List<ChoiceDto> choices;

  AddQuestionRequestBody({
    required this.text,
    required this.type,
    required this.points,
    required this.orderNumber,
    required this.choices,
  });

  factory AddQuestionRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AddQuestionRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AddQuestionRequestBodyToJson(this);
}

@JsonSerializable()
class AddQuestionResponse {
  @JsonKey(name: 'questionId')
  final int questionId;

  AddQuestionResponse({required this.questionId});

  factory AddQuestionResponse.fromJson(Map<String, dynamic> json) =>
      _$AddQuestionResponseFromJson(json);
}

@JsonSerializable()
class QuestionLocalDto {
  @JsonKey(name: 'questionId')
  final int? id;

  @JsonKey(name: 'questionText')
  final String text;

  @JsonKey(name: 'questionType')
  final String type;

  final int points;
  final int? orderNumber;
  final List<ChoiceDto> choices;

  QuestionLocalDto({
    this.id,
    required this.text,
    required this.type,
    required this.points,
    this.orderNumber,
    required this.choices,
  });

  factory QuestionLocalDto.fromJson(Map<String, dynamic> json) =>
      _$QuestionLocalDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionLocalDtoToJson(this);
}

/// Wrapper for GET /api/exams/{examId}/questions response
@JsonSerializable()
class ExamQuestionsWrapper {
  final int examId;
  final String examTitle;
  final bool isPublished;
  final int totalQuestions;
  final List<QuestionLocalDto> questions;

  ExamQuestionsWrapper({
    required this.examId,
    required this.examTitle,
    required this.isPublished,
    required this.totalQuestions,
    required this.questions,
  });

  factory ExamQuestionsWrapper.fromJson(Map<String, dynamic> json) =>
      _$ExamQuestionsWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$ExamQuestionsWrapperToJson(this);
}
