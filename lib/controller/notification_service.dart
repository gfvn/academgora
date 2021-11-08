import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<NotificationDetails> _notificationDetails() async {
    await _notifications.initialize(const InitializationSettings(
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
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void scheduleNotification(
      DateTime scheduledNotificationDateTime, int channelId) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '$channelId',
      'alarm_notif',
      'Channel for Alarm notification',
    );

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _notifications.schedule(channelId, 'Office', "title",
        scheduledNotificationDateTime, platformChannelSpecifics);
  }

  static void cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
}
