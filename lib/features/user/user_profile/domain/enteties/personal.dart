import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';

class User {
  String? id;
  String? phone;
  String? name;
  String? fcm_token;
  List<Workout>? workouts;

  static User fromJson(String id, map) {
    User user = User();
    user.id = id;
    user.name=map['ФИО'];
    user.phone = map["Телефон"] ?? "";
    user.fcm_token=map["fcm_token"]??"";
    // user.workouts = _parseWorkouts(map["Занятия"])??[];
    return user;
  }

  // static Map<dynamic, dynamic> _parseDates(
  //     Map<dynamic, dynamic>? schedule, String UserId) {
  //   if (schedule == null) {
  //     return {};
  //   } else {
  //     var parsedMap = {};
  //     schedule.forEach((date, value) {
  //       String formattedDate =
  //           "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
  //       DateTime dateTime = DateTime.parse(formattedDate);
  //       DateTime now = DateTime.now();
  //       if (now.isAfterDate(dateTime)) {
  //         _deleteOldDate(UserId, date);
  //       } else {
  //         parsedMap.putIfAbsent(date, () => value);
  //       }
  //     });
  //     return parsedMap;
  //   }
  // }

  // static void _deleteOldDate(String UserId, String dateString) {
  //   FirebaseRequestsController()
  //       .delete("Инструкторы/$UserId/График работы/$dateString");
  // }

  static List<Workout> _parseWorkouts(Map? data) {
    List<Workout> workouts = [];
    if (data != null && data.isNotEmpty) {
      data.forEach((key, value) {
        workouts.add(Workout.fromJson((key as String).split(" ")[1], value));
      });
    }
    return workouts;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}
