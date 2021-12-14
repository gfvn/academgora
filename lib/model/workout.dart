import 'visitor.dart';

class SportType {
  static const String snowboard = "Сноуборд";
  static const String skiing = "Горные лыжи";
}

class TimeStatus {
  static const String OPENED = "открыто";
  static const String NOT_OPENED = "не открыто";
  static const String NOT_AVAILABLE = "недоступно";
}

class Workout {
  String? id;
  String? sportType;
  String? date;
  String? from;
  String? to;
  String? instructorName;
  String? comment;
  String? instructorPhoneNumber;
  String? userPhoneNumber;
  int? peopleCount;
  int? workoutDuration;
  int? levelOfSkating;
  String? instructorFcmToken;
  List<Visitor> visitors = [];

  static Workout fromJson(String id, workoutData) {
    Workout workout = Workout();
    workout.id = id;
    workout.date = workoutData["Дата"];
    workout.from = (workoutData["Время"] as String).split('-')[0];
    workout.to = (workoutData["Время"] as String).split('-')[1];
    workout.instructorName = workoutData["Инструктор"];
    workout.instructorPhoneNumber = workoutData["Телефон инструктора"];
    workout.userPhoneNumber = workoutData["Телефон"];
    workout.peopleCount = workoutData["Количество человек"];
    workout.comment = workoutData["Комментарий"];
    workout.sportType = workoutData["Вид спорта"];
    workout.instructorFcmToken=workoutData["instructor_fcm_token"];
    workout.levelOfSkating = workoutData["Уровень катания"];
    workout.visitors = _parseVisitors(workoutData["Посетители"]);
    workout.workoutDuration = workoutData["Продолжительность"];
    return workout;
  }

  static List<Visitor> _parseVisitors(Map<dynamic, dynamic> visitors) {
    List<Visitor> visitorsList = [];
    visitors.forEach((key, value) {
      visitorsList.add(Visitor(value["Имя"], value["Возраст"]));
    });
    return visitorsList;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Workout && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class WorkoutDataKeeper {
  static final WorkoutDataKeeper _singleton = WorkoutDataKeeper._internal();

  String? id;
  String? sportType;
  String? date;
  String? from;
  String? temporaryFrom;
  String? to;
  int? peopleCount;
  int? workoutDuration;
  int? levelOfSkating;
  String? comment;
  String? fio;
  String? instructorId;
  int? age;
  String? instructorName;
  String? instructorPhoneNumber;
  String? instructorfcmToken;
  String? clientFcmToken; 
  List<Visitor>? visitors = [];

  factory WorkoutDataKeeper() {
    return _singleton;
  }

  WorkoutDataKeeper._internal();

  void clear() {
    id = null;
    sportType = null;
    date = null;
    temporaryFrom = null;
    from = null;
    to = null;
    peopleCount = null;
    workoutDuration = null;
    levelOfSkating = null;
    comment = null;
    fio = null;
    age = 0;
    instructorName = null;
    instructorPhoneNumber = null;
    visitors = [];
    instructorId = null;
    instructorfcmToken=null;
    clientFcmToken=null;
  }
}
