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
}
