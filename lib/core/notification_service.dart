import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        notificationCategories: [
          DarwinNotificationCategory(
            'demoCategory',
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('id_1', 'Action 1'),
              DarwinNotificationAction.plain(
                'id_2',
                'Action 2',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.destructive,
                },
              ),
              DarwinNotificationAction.plain(
                'id_3',
                'Action 3',
                options: <DarwinNotificationActionOption>{
                  DarwinNotificationActionOption.foreground,
                },
              ),
            ],
            options: <DarwinNotificationCategoryOption>{
              DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
            },
          ),
        ],
      );

  Future<void> initNotifications() async {
    await initializeLocalTime();
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        initializationSettingsDarwin;

    InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);

    final android = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        'reminder_channel',
        'Reminders',
        description: 'Check-in reminder notifications',
        importance: Importance.max,
      ),
    );
  }

  Future<void> initializeLocalTime() async {
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
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
          presentBadge: true,
          sound: 'default',
          badgeNumber: 1,
          threadIdentifier: 'reminder_thread',
          categoryIdentifier: 'reminder',
        ),
      ),
      payload: "",
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    print('Scheduling notification for: $scheduledDate');
  }

  void cancelReminder() {
    flutterLocalNotificationsPlugin.cancel(2);
  }

  Future<bool?> checkExactAlarmsPermission() async {
    final canScheduleExactAlarms = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
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
          'ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}, Payload: ${notification.payload}',
        );
      }
    }
  }
}
