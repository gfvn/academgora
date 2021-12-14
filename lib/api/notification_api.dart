import 'package:dio/dio.dart';

class NotificationApi {
  static const fireBaseKey =
      "AAAAzsvb2DU:APA91bEEjSIXdcSZ7tfuFNQfaVnULFY1Lju-Dzr5STC8wcm3RLxuLKviY2LC5jzvc2kjaefJyT5mDuMe6_TCR08M6ZZViOxZD4bFdLL_d3co09AMgyqZqdy6W4b4JqcjiUXc4_cKon2d";
  static const fireBaseUrl = 'https://fcm.googleapis.com/fcm/send';
  final Dio dio = Dio();
  static final NotificationApi _notificationApi = NotificationApi._internal();
  NotificationApi._internal();
  factory NotificationApi() {
    return _notificationApi;
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
