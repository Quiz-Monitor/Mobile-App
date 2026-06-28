import 'package:dio/dio.dart';
import 'package:examify/core/networking/api_error_handler.dart';
import 'package:examify/core/networking/api_result.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';

class ExamCreationRepo {
  final ApiService _apiService;

  ExamCreationRepo(this._apiService);

  Future<ApiResult<int>> createExam(CreateExamRequestBody body) async {
    try {
      final response = await _apiService.createExam(body);
      return ApiResult.success(response.id);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<int>> addQuestion(
    int examId,
    AddQuestionRequestBody body,
  ) async {
    try {
      final response = await _apiService.addExamQuestion(examId, body);
      return ApiResult.success(response.questionId);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> updateExamQuestion(
    int examId,
    int questionId,
    AddQuestionRequestBody body,
  ) async {
    try {
      await _apiService.updateExamQuestion(examId, questionId, body);
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<QuestionLocalDto>>> getExamQuestions(int examId) async {
    try {
      final questions = await _apiService.getExamQuestions(examId);
      return ApiResult.success(questions);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<void>> publishExam(int examId) async {
    try {
      await _apiService.publishExam(examId);
      return const ApiResult.success(null);
    } on DioException catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
