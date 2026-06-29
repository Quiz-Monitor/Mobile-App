import 'package:examify/core/di/service_locator.dart';
import 'package:examify/core/networking/api_service.dart';
import 'package:examify/features/instructor/home/data/models/exam_model.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ExamActionsHandler {
  static Future<void> publishExam(
    BuildContext context,
    ExamModel exam,
    VoidCallback onSuccess,
  ) async {
    toastification.show(
      context: context,
      title: const Text('Publishing exam...'),
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 2),
    );
    try {
      await getit<ApiService>().publishExam(exam.examId);
      if (context.mounted) {
        toastification.show(
          context: context,
          title: const Text('Exam published successfully!'),
          type: ToastificationType.success,
          autoCloseDuration: const Duration(seconds: 3),
        );
        onSuccess();
      }
    } catch (e) {
      if (context.mounted) {
        toastification.show(
          context: context,
          title: const Text('Failed to publish exam'),
          type: ToastificationType.error,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}
