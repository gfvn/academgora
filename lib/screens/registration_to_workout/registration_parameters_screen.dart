import 'dart:developer';

import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/data_keepers/notification_api.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/visitor.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../extension.dart';
import 'helpers_widgets/horizontal_divider.dart';
import 'helpers_widgets/reg_parameters/human_info_widget.dart';
import 'helpers_widgets/reg_parameters/info_text.dart';
import 'helpers_widgets/reg_parameters/select_duration_widget.dart';
import 'helpers_widgets/reg_parameters/select_level_of_skating_widget.dart';
import 'helpers_widgets/reg_parameters/select_people_count_widget.dart';
import 'reg_final_screen.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class RegistrationParametersScreen extends StatefulWidget {
  const RegistrationParametersScreen({Key? key}) : super(key: key);

  @override
  RegistrationParametersScreenState createState() =>
      RegistrationParametersScreenState();
}

class RegistrationParametersScreenState
    extends State<RegistrationParametersScreen> {
  WorkoutDataKeeper workoutSingleton = WorkoutDataKeeper();

  List<Pair> textEditingControllers = [];
  List<Visitor> visitors = [];
  int peopleCount = 0;
  int? duration;
  int? levelOfSkating;

  final TextEditingController _commentController = TextEditingController();
  final TimesController _timesController = TimesController();
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  @override
  void initState() {
    tz.initializeTimeZones();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              screenDecoration("assets/registration_parameters/0_bg.png"),
          child: SizedBox(
              width: screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _infoWidget(),
                    Container(
                        margin: const EdgeInsets.only(top: 12, left: 5),
                        child: SelectPeopleCountWidget(peopleCount, this)),
                    horizontalDivider(
                        10, 10, screenHeight * 0.015, screenHeight * 0.015),
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: SelectDurationWidget(duration, this)),
                    horizontalDivider(
                        10, 10, screenHeight * 0.015, screenHeight * 0.015),
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        child:
                            SelectLevelOfSkatingWidget(levelOfSkating, this)),
                    horizontalDivider(
                        10, 10, screenHeight * 0.015, screenHeight * 0.015),
                    SizedBox(
                        height: screenHeight * 0.19,
                        child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(3),
                            itemCount: peopleCount,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(left: 25),
                                child: HumanInfoWidget(
                                    index + 1, textEditingControllers, this),
                              );
                            })),
                    _commentFieldWidget(),
                    _dateFieldWidget(),
                    _continueButton()
                  ],
                ),
              ))),
    );
  }

  Widget _infoWidget() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.05),
        width: screenWidth * 0.9,
        height: screenHeight * 0.25,
        padding: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          image: DecorationImage(
            image: AssetImage("assets/registration_parameters/e_1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 30,
                    width: 30,
                    margin: EdgeInsets.only(right: screenWidth * 0.16),
                    child:
                        Image.asset("assets/registration_parameters/e_2.png")),
                Text(
                  InfoText.getLevelText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenHeight * 0.018),
                )
              ],
            ),
            Text(
              InfoText.getText(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: screenHeight * 0.018),
            ),
            Text(
              InfoText.getAge(),
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: screenHeight * 0.018),
            ),
          ],
        ));
  }

  Widget _commentFieldWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: Image.asset("assets/registration_parameters/e12.png")),
          Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.05,
            margin: const EdgeInsets.only(left: 5),
            child: TextField(
              controller: _commentController,
              maxLines: 10,
              style: const TextStyle(fontSize: 12),
              decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                  hintText: "Добавить комментарий",
                  hintStyle: TextStyle(fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  Widget _dateFieldWidget() {
    return Container(
      alignment: Alignment.bottomLeft,
      margin: const EdgeInsets.only(left: 15, top: 5),
      child: Text(
        _parseDateText(),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _parseDateText() {
    String dateFromSingleton = workoutSingleton.date!;
    String parsedDate = dateFromSingleton.substring(0, 2) +
        "." +
        dateFromSingleton.substring(2, 4) +
        "." +
        dateFromSingleton.substring(4, 8);
    return "Дата и время занятия: $parsedDate ${workoutSingleton.from}";
  }

  Widget _continueButton() {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _onBackPressed,
            child: const Icon(
              Icons.chevron_left,
              color: Colors.blue,
              size: 40,
            ),
          ),
          SizedBox(
            width: 170,
            height: screenHeight * 0.05,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(35)),
              color: _continueButtonBackgroundColor(),
              child: InkWell(
                onTap: peopleCount != null &&
                        levelOfSkating != null &&
                        duration != null &&
                        _checkTextControllers()
                    ? _sendData
                    : null,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ПРОДОЛЖИТЬ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _continueButtonTextColor(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _sendData() {
    workoutSingleton.peopleCount = peopleCount;
    workoutSingleton.levelOfSkating = levelOfSkating;
    _sendWorkoutDataToUser().then(
      (_) {
        _sendWorkoutDataToInstructor().then(
          (_) {
            countWorkoutTime();
            int norificationTime = countWorkoutTime();
            if (norificationTime > 0) {
              NotificationService().showNotification(
                  int.tryParse(workoutSingleton.id.toString()) ?? 0,
                  "Скоро занятия",
                  "Через 2 часа у вас будет занятие в АкадемГора",
                  norificationTime);
            } else {
              NotificationService().showNotification(2, "Скоро занятия",
                  "Вы записались на занятие в АкадемГора", 10);
            }
            String formattedDate =
                "${workoutSingleton.date!.substring(4, 8)}-${workoutSingleton.date!.substring(2, 4)}-${workoutSingleton.date!.substring(0, 2)}";
            NotificationService().sendNotificationToFcm(
                fcmToken: workoutSingleton.instructorfcmToken!,
                tittle: "Новая запись",
                body:
                    "У вас новая запись на $formattedDate, ${workoutSingleton.from}");
            _openRegFinalScreen();
          },
        );
      },
    );
  }

  int countWorkoutTime() {
    int seconds = 0;
    DateTime now = DateTime.now();
    String formattedDate =
        "${workoutSingleton.date?.substring(4, 8)}-${workoutSingleton.date?.substring(2, 4)}-${workoutSingleton.date?.substring(0, 2)}";
    DateTime workoutday = DateTime.parse(formattedDate);
    DateTime time = DateTime(
      workoutday.year,
      workoutday.month,
      workoutday.day,
      int.parse(
        "${workoutSingleton.from?.substring(0, 2)}",
      ),
      int.parse(
        "${workoutSingleton.from?.substring(3, 5)}",
      ),
    );
    seconds = time.difference(now).inSeconds - 5400;
    return seconds;
  }

  void _openRegFinalScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const RegistrationFinalScreen()),
        (route) => false);
  }

  Future<void> _sendWorkoutDataToUser() async {
    await UserRole.getUserRole().then(
      (userRole) => {
        if (userRole == UserRole.user)
          {
            _firebaseRequestsController.send(
                "$userRole/${FirebaseAuth.instance.currentUser!.uid}/Занятия/${workoutSingleton.id}",
                {
                  "id": workoutSingleton.id,
                  "Телефон инструктора": workoutSingleton.instructorPhoneNumber,
                  "Вид спорта": workoutSingleton.sportType,
                  "Время": _getWorkoutTime(),
                  "Дата": workoutSingleton.date,
                  "Инструктор": workoutSingleton.instructorName,
                  "Количество человек": workoutSingleton.peopleCount,
                  "Посетители": _humansMap(),
                  "Уровень катания": levelOfSkating,
                  "Продолжительность": workoutSingleton.workoutDuration,
                  "Комментарий": _commentController.text,
                  "instructor_fcm_token": workoutSingleton.instructorfcmToken,
                })
          },
      },
    );
  }

  Future<void> _sendWorkoutDataToInstructor() async {
    _firebaseRequestsController.send(
        "${UserRole.instructor}/${workoutSingleton.instructorId}/Занятия/Занятие ${workoutSingleton.id}",
        {
          "Вид спорта": workoutSingleton.sportType,
          "Время": _getWorkoutTime(),
          "Дата": workoutSingleton.date,
          "Количество человек": workoutSingleton.peopleCount,
          "Посетители": _humansMap(),
          "Уровень катания": levelOfSkating,
          "Комментарий": _commentController.text,
          "Продолжительность": workoutSingleton.workoutDuration,
          "Телефон": FirebaseAuth.instance.currentUser!.phoneNumber,
          "instructor_fcm_token": workoutSingleton.instructorfcmToken,
        });
    _firebaseRequestsController.update(
        "${UserRole.instructor}/${workoutSingleton.instructorId}/График работы/${workoutSingleton.date}",
        _timesController.setTimesStatus(
            workoutSingleton.from!, duration!, "недоступно"));
    _firebaseRequestsController.send("Log", {
      DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
          userRegisteredForInstructor(workoutSingleton.instructorPhoneNumber!,
              date: workoutSingleton.date!, time: workoutSingleton.from!)
    });
  }

  String _getWorkoutTime() {
    String from = workoutSingleton.from!;
    int duration = workoutSingleton.workoutDuration!;
    String to = _timesController
        .getTimeByValue(_timesController.times[from] + duration * 2);
    return "$from-$to";
  }

  Map<String, dynamic> _humansMap() {
    _checkTextControllers(addHumans: _addVisitors);
    Map<String, dynamic> map = {};
    for (var i = 0; i < visitors.length; ++i) {
      var human = visitors[i];
      map.putIfAbsent(
          "Посетитель ${i + 1}",
          () => {
                "Имя": human.name,
                "Возраст": human.age,
              });
    }
    return map;
  }

  Color _continueButtonBackgroundColor() {
    if (peopleCount != null &&
        levelOfSkating != null &&
        duration != null &&
        _checkTextControllers()) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color _continueButtonTextColor() {
    if (peopleCount != null &&
        levelOfSkating != null &&
        duration != null &&
        _checkTextControllers()) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  bool _checkTextControllers({Function? addHumans}) {
    if (textEditingControllers.isNotEmpty) {
      List<bool> conditions = [];
      for (var i = 0; i < peopleCount; ++i) {
        bool condition = textEditingControllers[i].left.text.isNotEmpty &&
            textEditingControllers[i].right.text.isNotEmpty &&
            isNumericUsing_tryParse(textEditingControllers[i].right.text);
        conditions.add(condition);
        if (addHumans != null && condition) {
          addHumans.call(textEditingControllers[i].left.text,
              int.parse(textEditingControllers[i].right.text));
        }
      }
      if (conditions.contains(false)) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  void _addVisitors(String name, int age) {
    Visitor visitor = Visitor(name, age);
    if (!visitors.contains(visitor)) visitors.add(visitor);
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }
}

bool isNumericUsing_tryParse(String? string) {
  if (string == null || string.isEmpty) {
    return false;
  }
  final number = num.tryParse(string);

  if (number == null) {
    return false;
  }
  return true;
}

//TODO: refactor move in other file
class Pair {
  Pair(this.left, this.right);

  final TextEditingController left;
  final TextEditingController right;
}
