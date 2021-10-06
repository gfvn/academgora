import 'package:academ_gora_release/controller/firebase_requests_controller.dart';
import 'package:academ_gora_release/controller/times_controller.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/data_keepers/user_workouts_keeper.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import '../../main.dart';
import '../extension.dart';
import '../main_screen.dart';
import 'helpers_widgets/workout_widget.dart';

class UserAccountScreen extends StatefulWidget {

  const UserAccountScreen({Key? key}) : super(key: key);

  @override
  UserAccountScreenState createState() => UserAccountScreenState();
}

class UserAccountScreenState extends State<UserAccountScreen> {
  List<Workout> workouts = [];
  FirebaseRequestsController _firebaseController = FirebaseRequestsController();

  @override
  Widget build(BuildContext context) {
    _getAllWorkouts();
    return Scaffold(
        body: Container(
      decoration: screenDecoration("assets/account/0_bg.png"),
      child: Column(
        children: [
          _topAccountInfo(),
          _workoutsTitle(),
          _workoutsList(),
          _backToMainScreenButton()
        ],
      ),
    ));
  }

  Widget _topAccountInfo() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.07, right: 10),
        child: Column(
          children: [_accountTextWidget(), _phoneTextWidget(), _logoutButton()],
        ));
  }

  Widget _accountTextWidget() {
    return Container(
        alignment: Alignment.topRight,
        child: Text(
          "Личный кабинет",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ));
  }

  Widget _phoneTextWidget() {
    return Container(
        margin: EdgeInsets.only(top: 6),
        alignment: Alignment.topRight,
        child: Text(
          FirebaseAuth.instance.currentUser!.phoneNumber!,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));
  }

  Widget _logoutButton() {
    return GestureDetector(
        onTap: () {
          showLogoutDialog(context, _logout);
        },
        child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "ВЫЙТИ",
                  style: TextStyle(color: Colors.white),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5),
                    height: 20,
                    width: 20,
                    child: Image.asset("assets/account/e1.png"))
              ],
            )));
  }

  Widget _backToMainScreenButton() {
    return GestureDetector(
        onTap: _openMainScreen,
        child: Container(
          alignment: Alignment.center,
          width: screenWidth * 0.5,
          height: screenHeight * 0.07,
          margin: EdgeInsets.only(top: screenHeight * 0.01),
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(26))),
          child: Text(
            "НА ГЛАВНУЮ",
            style: TextStyle(
                color: Colors.white,
                fontSize: screenHeight * 0.03,
                fontWeight: FontWeight.bold),
          ),
        ));
  }

  void _logout() async {
    FlutterAuthUi.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (c) => const AuthScreen()),
            (route) => false);
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => MainScreen()), (route) => false);
  }

  Widget _workoutsTitle() {
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20, bottom: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          "мои занятия",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ));
  }

  Widget _workoutsList() {
    return Container(
      height: screenHeight * 0.6,
      child: ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WorkoutWidget(
                    workout: workouts[index], userAccountScreenState: this),
                index != workouts.length - 1
                    ? Container(
                        height: 30,
                        width: 30,
                        child: Icon(Icons.keyboard_arrow_down),
                      )
                    : Container()
              ],
            ));
          }),
    );
  }

  void _getAllWorkouts() {
    List<Workout> workoutsFromKeeper = UserWorkoutsKeeper().workoutsList;
    List<Workout> workoutsTemp = [];
    for (var element in workoutsFromKeeper) {
      if (_compareWorkoutDates(element.date!)) {
        workoutsTemp.add(element);
      } else {
        _deleteWorkout(element.id!);
      }
    }
    if (!_checkListsEquality(workoutsTemp, workouts)) {
      workouts = _sortWorkouts(workoutsTemp);
    }
  }

  bool _checkListsEquality(
      List<Workout> serverList, List<Workout> currentList) {
    if (serverList.length != currentList.length) return false;
    for (var element in currentList) {
      if (!serverList.contains(element)) return false;
    }
    return true;
  }

  List<Workout> _sortWorkouts(List<Workout> workouts) {
    List<Workout> result = [];
    if (workouts.length > 1) {
      workouts.sort((first, second) {
        String formattedDateFirst =
            "${first.date!.substring(4, 8)}-${first.date!.substring(2, 4)}-${first.date!.substring(0, 2)}";
        DateTime workoutDateTimeFirst = DateTime.parse(formattedDateFirst);
        String formattedDateSecond =
            "${first.date!.substring(4, 8)}-${first.date!.substring(2, 4)}-${first.date!.substring(0, 2)}";
        DateTime workoutDateTimeSecond = DateTime.parse(formattedDateSecond);
        return workoutDateTimeFirst.millisecondsSinceEpoch -
            workoutDateTimeSecond.millisecondsSinceEpoch;
      });
      List<Workout> temp = [];
      String currentWorkoutsDate = workouts[0].date!;
      for (var i = 0; i < workouts.length; ++i) {
        if (currentWorkoutsDate == workouts[i].date) {
          temp.add(workouts[i]);
          if (i == workouts.length - 1) {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
          }
        } else {
          if (i == workouts.length - 1) {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
            result.add(workouts[i]);
          } else {
            temp = _sortWorkoutsByTime(temp);
            result.addAll(temp);
            temp = [];
            currentWorkoutsDate = workouts[i].date!;
            temp.add(workouts[i]);
          }
        }
      }
    } else {
      result = workouts;
    }
    return result;
  }

  List<Workout> _sortWorkoutsByTime(List<Workout> list) {
    TimesController timesController = TimesController();
    if (list.length > 0) {
      list.sort((first, second) {
        return timesController.times[first.from] -
            timesController.times[second.from];
      });
    }
    return list;
  }

  bool _compareWorkoutDates(String workoutDate) {
    String formattedDate =
        "${workoutDate.substring(4, 8)}-${workoutDate.substring(2, 4)}-${workoutDate.substring(0, 2)}";
    DateTime workoutDateTime = DateTime.parse(formattedDate);
    DateTime now = DateTime.now();
    if (workoutDateTime.year >= now.year &&
        workoutDateTime.day >= now.day &&
        workoutDateTime.month >= now.month) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteWorkout(String workoutId) {
    _firebaseController.delete(
        "${UserRole.user}/${FirebaseAuth.instance.currentUser!.uid}/Занятия/$workoutId");
  }

  @override
  void dispose() {
    super.dispose();
    InstructorsKeeper().removeListener(this);
  }
}
