import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails> _notificationDetails() async {
    await _notificationsPlugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher')
    ));
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            "channel_id", "channel_name", "channel_description",
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notificationsPlugin.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void scheduleNotification(
      DateTime scheduledNotificationDateTime, int channelId) async {
    var androidNotificationDetails = AndroidNotificationDetails(
      '$channelId',
      'alarm_notif',
      'Channel for Alarm notification',
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iOSPlatformChannelSpecifics);

    await _notificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}
