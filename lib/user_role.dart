import 'package:shared_preferences/shared_preferences.dart';

class UserRole {
  static const String user = "Пользователи";
  static const String instructor = "Инструкторы";
  static const String administrator = "Администраторы";

  static Future<String> getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRole = prefs.getString("userRole");
    return userRole ?? "";
  }
}
