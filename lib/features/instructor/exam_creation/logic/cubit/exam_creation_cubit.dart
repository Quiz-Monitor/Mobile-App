import 'package:examify/core/networking/api_result.dart';
import 'package:examify/features/instructor/exam_creation/data/models/exam_creation_models.dart';
import 'package:examify/features/instructor/exam_creation/data/repo/exam_creation_repo.dart';
import 'package:examify/features/instructor/exam_creation/logic/cubit/exam_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamCreationCubit extends Cubit<ExamCreationState> {
  final ExamCreationRepo _repo;
  int? currentExamId;
  CreateExamRequestBody? currentExamDetails;
  final List<QuestionLocalDto> addedQuestions = [];

  /// Monotonically increasing counter — never decreases, even after deletes.
  /// This prevents the "order number X already exists" backend error.
  int _nextOrderNumber = 1;

  ExamCreationCubit(this._repo) : super(ExamCreationInitial());

  Future<void> createExam(CreateExamRequestBody requestBody) async {
    emit(ExamCreationLoading());
    final result = await _repo.createExam(requestBody);
    result.when(
      success: (examId) {
        currentExamId = examId;
        currentExamDetails = requestBody;
        emit(ExamCreatedSuccess(examId));
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Unknown error occurred',
          ),
        );
      },
    );
  }

  /// Fetches questions from the server for the given [examId] and
  /// populates [addedQuestions].
  Future<void> loadExamQuestions(int examId) async {
    currentExamId = examId;
    emit(QuestionsLoading());
    final result = await _repo.getExamQuestions(examId);
    result.when(
      success: (questions) {
        addedQuestions
          ..clear()
          ..addAll(questions);
        // Sync counter so new questions always get a higher orderNumber
        if (addedQuestions.isNotEmpty) {
          final maxOrder = addedQuestions
              .map((q) => q.orderNumber ?? 0)
              .reduce((a, b) => a > b ? a : b);
          _nextOrderNumber = maxOrder + 1;
        }
        emit(QuestionsLoaded(List.of(addedQuestions)));
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to load questions',
          ),
        );
      },
    );
  }

  Future<void> addQuestion(
    String text,
    String type,
    int points,
    List<ChoiceDto> choices,
  ) async {
    if (currentExamId == null) {
      emit(ExamCreationError("Exam ID is missing. Please recreate the exam."));
      return;
    }

    emit(QuestionAdding());

    // Use the monotonic counter — never reuses a number even after deletes
    final orderNumber = _nextOrderNumber;

    final body = AddQuestionRequestBody(
      text: text,
      type: type,
      points: points,
      orderNumber: orderNumber,
      choices: choices,
    );

    final result = await _repo.addQuestion(currentExamId!, body);
    result.when(
      success: (questionId) {
        addedQuestions.add(
          QuestionLocalDto(
            id: questionId,
            text: text,
            type: type,
            points: points,
            orderNumber: orderNumber,
            choices: choices,
          ),
        );
        // Increment ONLY on success so the number isn't wasted on failure
        _nextOrderNumber++;
        emit(QuestionAddedSuccess());
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to add question',
          ),
        );
      },
    );
  }

  Future<void> editQuestion(
    int questionId,
    String text,
    String type,
    int points,
    List<ChoiceDto> choices,
  ) async {
    if (currentExamId == null) {
      emit(ExamCreationError("Exam ID is missing."));
      return;
    }

    emit(QuestionUpdating());

    // Preserve existing orderNumber or fallback to a default
    final existingQuestion = addedQuestions.firstWhere(
      (q) => q.id == questionId,
      orElse: () => QuestionLocalDto(
        id: questionId,
        text: text,
        type: type,
        points: points,
        orderNumber: addedQuestions.length + 1,
        choices: choices,
      ),
    );

    final body = AddQuestionRequestBody(
      text: text,
      type: type,
      points: points,
      orderNumber: existingQuestion.orderNumber ?? addedQuestions.length + 1,
      choices: choices,
    );

    final result = await _repo.updateExamQuestion(
      currentExamId!,
      questionId,
      body,
    );
    result.when(
      success: (_) {
        final index = addedQuestions.indexWhere((q) => q.id == questionId);
        if (index != -1) {
          addedQuestions[index] = QuestionLocalDto(
            id: questionId,
            text: text,
            type: type,
            points: points,
            orderNumber:
                existingQuestion.orderNumber ?? addedQuestions.length + 1,
            choices: choices,
          );
        }
        emit(QuestionUpdatedSuccess());
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to update question',
          ),
        );
      },
    );
  }

  Future<void> deleteQuestion(int questionId) async {
    if (currentExamId == null) {
      emit(ExamCreationError("Exam ID is missing."));
      return;
    }

    emit(QuestionDeleting());

    final result = await _repo.deleteExamQuestion(currentExamId!, questionId);
    result.when(
      success: (_) {
        addedQuestions.removeWhere((q) => q.id == questionId);
        emit(QuestionDeletedSuccess());
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to delete question',
          ),
        );
      },
    );
  }

  Future<void> publishExam() async {
    if (currentExamId == null) {
      emit(ExamCreationError("Exam ID is missing."));
      return;
    }

    emit(ExamPublishing());
    final result = await _repo.publishExam(currentExamId!);
    result.when(
      success: (_) {
        emit(ExamPublishedSuccess());
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to publish exam',
          ),
        );
      },
    );
  }

  Future<void> updateExamInfo(int examId, CreateExamRequestBody body) async {
    emit(ExamUpdateLoading());
    final result = await _repo.updateExam(examId, body);
    result.when(
      success: (_) {
        emit(ExamUpdatedSuccess());
      },
      failure: (error) {
        emit(
          ExamCreationError(
            error.apiErrorModel.message ?? 'Failed to update exam',
          ),
        );
      },
    );
  }
}
