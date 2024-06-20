import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleDailyTenAMNotification() async {
    print("Goes to the schedule daily");
    await notificationsPlugin.zonedSchedule(
        0,
        'AI Face Swap ',
        "Swap Face With AI Technology",
        _nextInstanceOfTenAM(),
        const NotificationDetails(
            android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description',
            ),
            iOS: DarwinNotificationDetails(
                sound: 'default.wav',
                presentAlert: true,
                presentBadge: true,
                presentSound: true)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation('Asia/Kolkata'),
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        9,
        0,
        0);
    if (scheduledDate.isBefore(DateTime.now())) {
      scheduledDate = scheduledDate.add(const Duration(hours: 12));
    }
    return scheduledDate;
  }
}
