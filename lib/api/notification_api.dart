class NotificationApi{
  static const fireBaseKey="";
  static const fireBaseUrl='https://fcm.googleapis.com/fcm/send';

  static final NotificationApi _notificationApi=NotificationApi._internal();
    NotificationApi._internal();

  factory NotificationApi() {
    return _notificationApi;
  }

}