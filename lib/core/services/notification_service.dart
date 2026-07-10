import 'package:examify/features/student/home/data/model/student_exam_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

/// Handles scheduling local notifications for upcoming exams.
///
/// Schedules two notifications per upcoming exam:
/// - 10 minutes before start time
/// - At the exact start time
///
/// For exams that are already live (started), fires an immediate notification.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'exam_reminders';
  static const String _channelName = 'Exam Reminders';
  static const String _channelDesc =
      'Notifications for upcoming and live exam reminders';

  bool _initialized = false;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Initialize the plugin and timezone data. Safe to call multiple times.
  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    if (!kIsWeb) {
      try {
        final currentTimeZone = await FlutterTimezone.getLocalTimezone();
        // Since we got a type error, let's cast dynamically or revert to the `.identifier`
        tz.setLocalLocation(
          tz.getLocation(
            (currentTimeZone as dynamic).identifier ??
                currentTimeZone.toString(),
          ),
        );
        debugPrint('[NotificationService] Timezone set');
      } catch (e) {
        debugPrint('[NotificationService] Could not get local timezone: $e');
        // Fall back to UTC so the rest of the service still works.
        tz.setLocalLocation(tz.UTC);
      }
    }

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
    debugPrint('[NotificationService] Initialized successfully.');
  }

  /// Request notification & exact alarm permissions (Android 12+/13+).
  Future<void> requestPermissions() async {
    if (kIsWeb) return;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // POST_NOTIFICATIONS permission (Android 13+)
      final notifGranted = await androidPlugin.requestNotificationsPermission();
      debugPrint(
        '[NotificationService] Notification permission granted: $notifGranted',
      );

      // Exact alarm permission (Android 12+)
      final alarmGranted = await androidPlugin.requestExactAlarmsPermission();
      debugPrint(
        '[NotificationService] Exact alarm permission granted: $alarmGranted',
      );
    }
  }

  /// Schedule "10 min before" and "starts now" notifications for each exam.
  /// Also fires an immediate notification for exams that are already live.
  Future<void> scheduleExamNotifications(List<StudentExamModel> exams) async {
    if (kIsWeb) return;

    final now = DateTime.now();

    for (final exam in exams) {
      final tenMinBefore = exam.startTime.subtract(const Duration(minutes: 10));

      if (exam.isLive) {
        // Exam already started → fire an immediate "live now" notification.
        debugPrint(
          '[NotificationService] Exam "${exam.examTitle}" is live — '
          'showing immediate notification.',
        );
        await _showImmediateNotification(
          id: _notificationId(exam.examCode, suffix: 1),
          title: '🚀 Exam is Live Now!',
          body:
              '"${exam.examTitle}" has already started! Join now before it ends.',
        );
      } else {
        // Exam is upcoming — schedule the two timed notifications.

        // ── 10 minutes before ──────────────────────────────────────────────
        if (tenMinBefore.isAfter(now)) {
          debugPrint(
            '[NotificationService] Scheduling 10-min reminder for '
            '"${exam.examTitle}" at $tenMinBefore',
          );
          await _scheduleNotification(
            id: _notificationId(exam.examCode, suffix: 0),
            title: '⏰ Exam Starting Soon!',
            body: '"${exam.examTitle}" starts in 10 minutes!',
            scheduledDate: tenMinBefore,
          );
        } else if (exam.startTime.isAfter(now)) {
          // Less than 10 minutes left — fire immediately so the user still
          // gets a heads-up.
          debugPrint(
            '[NotificationService] Less than 10 min left for '
            '"${exam.examTitle}" — showing immediate reminder.',
          );
          final minutesLeft = exam.startTime.difference(now).inMinutes;
          await _showImmediateNotification(
            id: _notificationId(exam.examCode, suffix: 0),
            title: '⏰ Exam Starting Very Soon!',
            body:
                '"${exam.examTitle}" starts in ~$minutesLeft minute(s)! Get ready.',
          );
        }

        // ── At start time ──────────────────────────────────────────────────
        if (exam.startTime.isAfter(now)) {
          debugPrint(
            '[NotificationService] Scheduling start-time notification for '
            '"${exam.examTitle}" at ${exam.startTime}',
          );
          await _scheduleNotification(
            id: _notificationId(exam.examCode, suffix: 1),
            title: '🚀 Exam Starting Now!',
            body: '"${exam.examTitle}" is starting now! Good luck!',
            scheduledDate: exam.startTime,
          );
        }
      }
    }
  }

  /// Cancel all previously scheduled notifications.
  Future<void> cancelAllNotifications() async {
    if (kIsWeb) return;
    await _plugin.cancelAll();
    debugPrint('[NotificationService] All notifications cancelled.');
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  /// Shows a notification immediately (not scheduled).
  Future<void> _showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = _buildNotificationDetails(body);
    await _plugin.show(id, title, body, details);
  }

  /// Schedules a notification at [scheduledDate] using the device's local TZ.
  Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final tzScheduled = tz.TZDateTime.from(scheduledDate, tz.local);

    // Guard: never schedule in the past (can happen with clock drift).
    if (tzScheduled.isBefore(tz.TZDateTime.now(tz.local))) {
      debugPrint(
        '[NotificationService] Skipping past-dated notification (id=$id).',
      );
      return;
    }

    final details = _buildNotificationDetails(body);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Builds the platform-specific notification details.
  NotificationDetails _buildNotificationDetails(String body) {
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(body),
      // Show on lock screen
      visibility: NotificationVisibility.public,
    );

    return NotificationDetails(android: androidDetails);
  }

  /// Generates a unique, deterministic notification ID from the exam code.
  /// [suffix] distinguishes the "10-min" (0) and "start-time" (1) notifications.
  int _notificationId(String examCode, {required int suffix}) {
    final base = examCode.hashCode.abs() % 500000;
    return base * 2 + suffix;
  }

  /// Called when the user taps a notification (foreground or background).
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint(
      '[NotificationService] Notification tapped — payload: ${response.payload}',
    );
    // TODO: navigate to the relevant exam screen using the payload.
  }
}
