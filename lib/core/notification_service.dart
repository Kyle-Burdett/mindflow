import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
    initializeTimeZones();
  }

  void initializeTimeZones() {
    tz.initializeTimeZones();
  }

  void scheduleReminder(DateTime dateTime) {
    flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      "Clarity Desk Check-in",
      "Remember to complete your daily check-in!",
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time
    );
  }

  Future<void> checkExactAlarmsPermission() async {
  final canScheduleExactAlarms =
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();

  if (canScheduleExactAlarms == false) {
    // Optionally, show a dialog asking user to allow exact alarms in settings
  }
}
}