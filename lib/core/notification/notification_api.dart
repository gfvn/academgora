import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationApi {
  static const fireBaseKey =
      "AAAAzsvb2DU:APA91bEEjSIXdcSZ7tfuFNQfaVnULFY1Lju-Dzr5STC8wcm3RLxuLKviY2LC5jzvc2kjaefJyT5mDuMe6_TCR08M6ZZViOxZD4bFdLL_d3co09AMgyqZqdy6W4b4JqcjiUXc4_cKon2d";
  static const fireBaseUrl = 'https://fcm.googleapis.com/fcm/send';

  final Dio dio = Dio();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationApi _notificationApi = NotificationApi._internal();
  NotificationApi._internal();
  factory NotificationApi() {
    return _notificationApi;
  }
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

   AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  Future<String> setupNotification() async {
    String token = '';
    Stream<String> _tokenStream;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.requestPermission();
    token = await FirebaseMessaging.instance.getToken() ?? "no token";
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    return token;
  }

  Future<void> sendFcmNotification(
      String fcmToken, String tittle, String body) async {
    final data = {
      "to": fcmToken,
      "notification": {"body": body, "title": tittle}
    };
    await dio.post(
      fireBaseUrl,
      options: Options(
        headers: {
          "Authorization": "key=$fireBaseKey",
        },
      ),
      data: data,
    );
  }
}
