// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instructor_statistics_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstructorStatisticsResponse _$InstructorStatisticsResponseFromJson(
  Map<String, dynamic> json,
) => InstructorStatisticsResponse(
  examOverview: json['examOverview'] == null
      ? null
      : ExamOverviewDto.fromJson(json['examOverview'] as Map<String, dynamic>),
  studentOverview: json['studentOverview'] == null
      ? null
      : StudentOverviewDto.fromJson(
          json['studentOverview'] as Map<String, dynamic>,
        ),
  scoreStatistics: json['scoreStatistics'] == null
      ? null
      : ScoreStatisticsDto.fromJson(
          json['scoreStatistics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$InstructorStatisticsResponseToJson(
  InstructorStatisticsResponse instance,
) => <String, dynamic>{
  'examOverview': instance.examOverview,
  'studentOverview': instance.studentOverview,
  'scoreStatistics': instance.scoreStatistics,
};

ExamOverviewDto _$ExamOverviewDtoFromJson(Map<String, dynamic> json) =>
    ExamOverviewDto(
      totalExamsCreated: (json['totalExamsCreated'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExamOverviewDtoToJson(ExamOverviewDto instance) =>
    <String, dynamic>{'totalExamsCreated': instance.totalExamsCreated};

StudentOverviewDto _$StudentOverviewDtoFromJson(Map<String, dynamic> json) =>
    StudentOverviewDto(
      totalUniqueStudents: (json['totalUniqueStudents'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StudentOverviewDtoToJson(StudentOverviewDto instance) =>
    <String, dynamic>{'totalUniqueStudents': instance.totalUniqueStudents};

ScoreStatisticsDto _$ScoreStatisticsDtoFromJson(Map<String, dynamic> json) =>
    ScoreStatisticsDto(
      averageScorePercentage: (json['averageScorePercentage'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$ScoreStatisticsDtoToJson(ScoreStatisticsDto instance) =>
    <String, dynamic>{
      'averageScorePercentage': instance.averageScorePercentage,
    };
