import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Handles scheduling local notifications for upcoming exams.
///
/// Schedules two notifications per exam:
/// - 10 minutes before start time
/// - At the exact start time
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'exam_reminders';
  static const String _channelName = 'Exam Reminders';
  static const String _channelDesc =
      'Notifications for upcoming exam reminders';

  /// Initialize the plugin and timezone data.
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  /// Request notification & exact alarm permissions (Android 13+).
  Future<void> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Request POST_NOTIFICATIONS permission (Android 13+)
      await androidPlugin.requestNotificationsPermission();
      // Request exact alarm permission (Android 12+)
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  /// Schedule "10 min before" and "starts now" notifications for each exam.
  Future<void> scheduleExamNotifications(List<StudentExamModel> exams) async {
    for (final exam in exams) {
      final now = DateTime.now();

      // --- 10 minutes before ---
      final tenMinBefore = exam.startTime.subtract(const Duration(minutes: 10));
      if (tenMinBefore.isAfter(now)) {
        await _scheduleNotification(
          id: _notificationId(exam.examCode, isReminder: true),
          title: '⏰ Exam Starting Soon!',
          body: 'Your exam "${exam.examTitle}" starts in 10 minutes!',
          scheduledDate: tenMinBefore,
        );
      }

      // --- At start time ---
      if (exam.startTime.isAfter(now)) {
        await _scheduleNotification(
          id: _notificationId(exam.examCode, isReminder: false),
          title: '🚀 Exam Starting Now!',
          body: 'Your exam "${exam.examTitle}" is starting now! Good luck!',
          scheduledDate: exam.startTime,
        );
      }
    }
  }

  /// Cancel all previously scheduled notifications.
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(body),
    );

    final details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Generates a unique, deterministic notification ID per exam + type.
  int _notificationId(String examCode, {required bool isReminder}) {
    // Use absolute value to avoid negative IDs, multiply by 2 to create pairs.
    final base = examCode.hashCode.abs() % 100000;
    return isReminder ? base * 2 : base * 2 + 1;
  }
}
