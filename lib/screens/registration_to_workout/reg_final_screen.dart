import 'package:academ_gora_release/core/user_role.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';
import 'package:academ_gora_release/features/user/user_profile/presentation/user_account_screen.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/administrator_profile_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/instructor_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';
import '../../features/main_screen/ui/screens/main_screen/main_screen.dart';

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
          margin: EdgeInsets.only(top: screenHeight * 0.15),
          child: Column(
            children: [
              _textWidget("Запись оформлена\n"),
              _textWidget(
                  "Ждем вас на занятии\n${_parseDate(workoutSingleton.date!)} в ${workoutSingleton.from}\nв СК \"Академический\"\n"),
              _textWidget("Информация о занятии\nдоступна в личном\nкабинете"),
              _buttonWidget("В личный кабинет", screenHeight * 0.3),
              _buttonWidget("На главную", 20),
            ],
          ),
        ),
      ),
    );
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
        color: kMainColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAccount() async {
    await SharedPreferences.getInstance().then(
      (prefs) {
        String userRole = prefs.getString("userRole")!;
        if (userRole == UserRole.user) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (c) => const UserAccountScreen()));
        } else if (userRole == UserRole.instructor) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => const InstructorWorkoutsScreen()));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (c) => const AdministratorProfileScreen(),
            ),
          );
        }
      },
    );
  }

  void _openMain() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (c) => const MainScreen(),
      ),
      (route) => false,
    );
  }
}
