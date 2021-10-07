import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/account/administrator_profile/administrator_profile_screen.dart';
import 'package:academ_gora_release/screens/account/instructor_profile/instructor_workouts_screen.dart';
import 'package:academ_gora_release/screens/account/user_profile/presentation/user_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../extension.dart';
import '../main_screen.dart';

class RegistrationFinalScreen extends StatefulWidget {

  const RegistrationFinalScreen({Key? key}) : super(key: key);

  @override
  _RegistrationFinalScreenState createState() =>
      _RegistrationFinalScreenState();
}

class _RegistrationFinalScreenState extends State<RegistrationFinalScreen> {
  WorkoutDataKeeper workoutSingleton = WorkoutDataKeeper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: screenDecoration("assets/reg_final/0_bg.png"),
            child: Container(
              margin: EdgeInsets.only(top: screenHeight * 0.1),
              child: Column(
                children: [
                  _textWidget("Запись оформлена\n"),
                  _textWidget(
                      "Ждем вас на занятии\n${_parseDate(workoutSingleton.date!)} в ${workoutSingleton.from}\nв СК \"Академический\"\n"),
                  _textWidget(
                      "Информация о занятии\nдоступна в личном\nкабинете"),
                  _buttonWidget("В личный кабинет", screenHeight * 0.3),
                  _buttonWidget("На главную", 20),
                ],
              ),
            )));
  }

  String _parseDate(String date) {
    return "${date.substring(0, 2)}.${date.substring(2, 4)}.${date.substring(4, 8)}";
  }

  Widget _textWidget(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget _buttonWidget(String text, double marginTop) {
    return Container(
      width: 280.0,
      height: screenHeight * 0.09,
      margin: EdgeInsets.only(top: marginTop),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: text == "В личный кабинет"
                ? () => _openAccount()
                : () => _openMain(),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  void _openAccount() async {
    await SharedPreferences.getInstance().then((prefs) {
      String userRole = prefs.getString("userRole")!;
      if (userRole == UserRole.user) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (c) => const UserAccountScreen()));
      } else if (userRole == UserRole.instructor) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => InstructorWorkoutsScreen()));
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => AdministratorProfileScreen()));
      }
    });
  }

  void _openMain() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()), (route) => false);
  }
}