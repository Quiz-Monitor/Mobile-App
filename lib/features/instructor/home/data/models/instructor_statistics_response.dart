import 'package:json_annotation/json_annotation.dart';

part 'instructor_statistics_response.g.dart';

@JsonSerializable()
class InstructorStatisticsResponse {
  final ExamOverviewDto? examOverview;
  final StudentOverviewDto? studentOverview;
  final ScoreStatisticsDto? scoreStatistics;

  InstructorStatisticsResponse({
    this.examOverview,
    this.studentOverview,
    this.scoreStatistics,
  });

  factory InstructorStatisticsResponse.fromJson(Map<String, dynamic> json) {
    var rawData = json;
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      rawData = json['data'] as Map<String, dynamic>;
    } else if (json.containsKey('payload') &&
        json['payload'] is Map<String, dynamic>) {
      rawData = json['payload'] as Map<String, dynamic>;
    }
    return _$InstructorStatisticsResponseFromJson(rawData);
  }
}

@JsonSerializable()
class ExamOverviewDto {
  final int? totalExamsCreated;

  ExamOverviewDto({this.totalExamsCreated});

  factory ExamOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$ExamOverviewDtoFromJson(json);
}

@JsonSerializable()
class StudentOverviewDto {
  final int? totalUniqueStudents;

  StudentOverviewDto({this.totalUniqueStudents});

  factory StudentOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$StudentOverviewDtoFromJson(json);
}

@JsonSerializable()
class ScoreStatisticsDto {
  final double? averageScorePercentage;

  ScoreStatisticsDto({this.averageScorePercentage});

  factory ScoreStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$ScoreStatisticsDtoFromJson(json);
}
