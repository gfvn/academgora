import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/visitor.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/profile/reg_parameters/human_info_widget.dart';
import 'package:academ_gora_release/screens/profile/reg_parameters/select_level_of_skating_widget.dart';
import 'package:academ_gora_release/screens/profile/reg_parameters/select_people_count_widget.dart';
import 'package:academ_gora_release/screens/profile/user_profile/presentation/user_account_screen.dart';
import 'package:academ_gora_release/screens/registration_to_workout/helpers_widgets/horizontal_divider.dart';
import 'package:academ_gora_release/screens/registration_to_workout/helpers_widgets/reg_parameters/info_text.dart';
import 'package:academ_gora_release/screens/registration_to_workout/registration_parameters_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../extension.dart';

class UpdateWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const UpdateWorkoutScreen(this.workout, {Key? key}) : super(key: key);

  @override
  UpdateWorkoutScreenState createState() => UpdateWorkoutScreenState();
}

class UpdateWorkoutScreenState extends State<UpdateWorkoutScreen> {
  List<Pair> textEditingControllers = [];
  List<Visitor> visitors = [];
  int peopleCount = 0;
  int? levelOfSkating;
  TextEditingController? _commentEditingController;
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  @override
  void initState() {
    super.initState();
    peopleCount = widget.workout.peopleCount!;
    _commentEditingController =
        TextEditingController(text: widget.workout.comment);
    for (var i = 0; i < peopleCount; ++i) {
      TextEditingController nameController =
          TextEditingController(text: widget.workout.visitors[i].name);
      TextEditingController ageController = TextEditingController(
          text: widget.workout.visitors[i].age.toString());
      textEditingControllers.add(Pair(nameController, ageController));
      levelOfSkating = widget.workout.levelOfSkating!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              screenDecoration("assets/registration_parameters/0_bg.png"),
          child: Container(
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
                        child:
                            SelectLevelOfSkatingWidget(levelOfSkating!, this)),
                    horizontalDivider(
                        10, 10, screenHeight * 0.015, screenHeight * 0.015),
                    Container(
                        height: screenHeight * 0.19,
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(3),
                            itemCount: peopleCount,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.only(left: 25),
                                child: HumanInfoWidget(
                                    index + 1, textEditingControllers, this),
                              );
                            })),
                    _commentFieldWidget(),
                    _saveButton()
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
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
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
                Container(
                    child: Text(
                  InfoText.getLevelText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: screenHeight * 0.018),
                ))
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
      margin: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/registration_parameters/e12.png")),
          Container(
            width: screenWidth * 0.85,
            height: screenHeight * 0.06,
            margin: const EdgeInsets.only(left: 5),
            child: TextField(
              controller: _commentEditingController,
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

  Widget _saveButton() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
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
          Container(
            width: 170,
            height: screenHeight * 0.06,
            child: Material(
              borderRadius: const BorderRadius.all(Radius.circular(35)),
              color: _continueButtonBackgroundColor(),
              child: InkWell(
                onTap: peopleCount != null &&
                        levelOfSkating != null &&
                        _checkTextControllers()
                    ? _saveChanges
                    : null,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Сохранить",
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

  void _saveChanges() async {
    _saveChangesForUser().then((_) {
      _saveChangesForInstructor().then((value) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const UserAccountScreen()),
            (route) => false);
      });
    });
  }

  Future<void> _saveChangesForUser() async {
    FirebaseDatabase.instance
        .reference()
        .child(
            "${UserRole.user}/${FirebaseAuth.instance.currentUser!.uid}/Занятия/${widget.workout.id}")
        .set({
      "Вид спорта": widget.workout.sportType,
      "Время": "${widget.workout.from}-${widget.workout.to}",
      "Дата": widget.workout.date,
      "Количество человек": peopleCount,
      "Посетители": _humansMap(),
      "Уровень катания": levelOfSkating,
      "Комментарий": _commentEditingController!.text,
      "Продолжительность": widget.workout.workoutDuration,
      "Телефон инструктора": widget.workout.instructorPhoneNumber,
      "instructor_fcm_token": widget.workout.instructorFcmToken,
    });
  }

  Future<void> _saveChangesForInstructor() async {
    Instructor instructor = _instructorsKeeper
        .findInstructorByPhoneNumber(widget.workout.instructorPhoneNumber!)!;
    FirebaseDatabase.instance
        .reference()
        .child(
            "${UserRole.instructor}/${instructor.id}/Занятия/Занятие ${widget.workout.id}")
        .set({
      "Вид спорта": widget.workout.sportType,
      "Время": "${widget.workout.from}-${widget.workout.to}",
      "Дата": widget.workout.date,
      "Количество человек": peopleCount,
      "Посетители": _humansMap(),
      "Уровень катания": levelOfSkating,
      "Комментарий": _commentEditingController!.text,
      "Продолжительность": widget.workout.workoutDuration,
      "Телефон": FirebaseAuth.instance.currentUser!.phoneNumber!,
      "instructor_fcm_token": widget.workout.instructorFcmToken,
    });
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

  void _addVisitors(String name, int age) {
    if (!visitors.contains(Visitor(name, age))) {
      visitors.add(Visitor(name, age));
    }
  }

  Color _continueButtonBackgroundColor() {
    if (peopleCount != 0 && levelOfSkating != null && _checkTextControllers()) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color _continueButtonTextColor() {
    if (peopleCount != 0 && levelOfSkating != null && _checkTextControllers()) {
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

  void _onBackPressed() {
    Navigator.of(context).pop();
  }
}

bool isNumericUsing_tryParse(String string) {
  if (string == null || string.isEmpty) {
    return false;
  }
  final number = num.tryParse(string);

  if (number == null) {
    return false;
  }
  return true;
}
