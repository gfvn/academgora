import 'package:shared_preferences/shared_preferences.dart';

class UserRole {
  static const String user = "Пользователи";
  static const String instructor = "Инструкторы";
  static const String administrator = "Администраторы";

  static Future<String> getUserRole() async =>
      (await SharedPreferences.getInstance()).getString("userRole") ?? "unauth";

  static Future<bool> checkUserAuth() async {
    var user = await getUserRole();
    if (user == "unauth") {
      return false;
    }
    return true;
  }

  static Future<bool> isFiresOpen() async {
    bool isFirst =
        (await SharedPreferences.getInstance()).getBool("isFirst") ?? false;
    return !isFirst;
  }

  static Future<void> changeIsFirst() async {
    (await SharedPreferences.getInstance()).setBool("isFirst", true);
  }
}
