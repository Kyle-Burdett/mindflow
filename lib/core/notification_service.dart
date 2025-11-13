import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    await initializeTimeZones();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> initializeTimeZones() async {
    tz.initializeTimeZones();
    final TimezoneInfo? timeZoneInfo = await FlutterTimezone.getLocalTimezone();
    final String? timeZoneName = timeZoneInfo!.identifier;
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  void scheduleReminder(DateTime dateTime) async {
    if (await checkExactAlarmsPermission() != true) {
      return;
    }
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      dateTime.hour,
      dateTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await flutterLocalNotificationsPlugin.cancel(2);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      "Clarity Desk Check-in",
      "Remember to complete your daily check-in!",
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
          playSound: true,
          visibility: NotificationVisibility.public,
        ),
      ),
      payload: "",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime
    );
    print('Scheduling notification for: $scheduledDate');
  }

  Future<bool?> checkExactAlarmsPermission() async {
  final canScheduleExactAlarms =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
  return canScheduleExactAlarms;
}

Future<void> printScheduledNotifications() async {
  final List<PendingNotificationRequest> pending =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();

  if (pending.isEmpty) {
    print("No notifications scheduled.");
  } else {
    for (var notification in pending) {
      print(
          'ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}');
    }
  }
}
}