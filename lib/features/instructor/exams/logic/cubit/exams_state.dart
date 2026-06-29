import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exams_state.freezed.dart';

@freezed
class ExamsState with _$ExamsState {
  const factory ExamsState.initial() = _Initial;
  const factory ExamsState.loading() = _Loading;
  const factory ExamsState.success({
    required List<ExamModel> exams,
    @Default(<int, int>{}) Map<int, int> enrolledCounts,
  }) = _Success;
  const factory ExamsState.failure(String message) = _Failure;
}
