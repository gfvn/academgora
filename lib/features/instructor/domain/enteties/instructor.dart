import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';
import 'package:academ_gora_release/core/consants/extension.dart';

class Instructor {
  String? id;
  String? name;
  String? phone;
  String? photoUrl;
  String? info;
  String? kindOfSport;
  String? fcmToken;
  List<Workout>? workouts;
  List<String>? openedTimes=[];
  Map<dynamic, dynamic>? socialNetworks;
  Map<dynamic, dynamic>? schedule;

  static Instructor fromJson(String id, map) {
    Instructor instructor = Instructor();
    instructor.id = id;
    instructor.name = map["ФИО"];
    instructor.phone = map["Телефон"];
    instructor.photoUrl = map["Фото"];
    instructor.workouts = _parseWorkouts(map["Занятия"]);
    instructor.info = map["Информация"];
    instructor.socialNetworks = map["Соцсети"];
    instructor.schedule = _parseDates(map["График работы"], id);
    instructor.kindOfSport = map["Вид спорта"];
    instructor.fcmToken=map["fcm_token"];
    instructor.openedTimes=[];
    return instructor;
  }

  static Map<dynamic, dynamic> _parseDates(
      Map<dynamic, dynamic>? schedule, String instructorId) {
    if (schedule == null) {
      return {};
    } else {
      var parsedMap = {};
      schedule.forEach((date, value) {
        String formattedDate =
            "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
        DateTime dateTime = DateTime.parse(formattedDate);
        DateTime now = DateTime.now();
        if (now.isAfterDate(dateTime)) {
          _deleteOldDate(instructorId, date);
        } else {
          parsedMap.putIfAbsent(date, () => value);
        }
      });
      return parsedMap;
    }
  }

  static void _deleteOldDate(String instructorId, String dateString) {
    FirebaseRequestsController()
        .delete("Инструкторы/$instructorId/График работы/$dateString");
  }

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
      other is Instructor &&
          runtimeType == other.runtimeType &&
          phone == other.phone;

  @override
  int get hashCode => phone.hashCode;
}
