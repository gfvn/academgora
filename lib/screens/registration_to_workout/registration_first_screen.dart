import 'package:academ_gora_release/model/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';
import '../main_screen.dart';
import 'helpers_widgets/horizontal_divider.dart';
import 'helpers_widgets/reg_to_instructor/date_widget.dart';
import 'helpers_widgets/reg_to_instructor/select_kind_of_sport.dart';
import 'helpers_widgets/reg_to_instructor/time_widget.dart';
import 'instructors_list_screen.dart';

import 'package:intl/intl.dart';

class RegistrationFirstScreen extends StatefulWidget {
  const RegistrationFirstScreen({Key? key}) : super(key: key);

  @override
  RegistrationFirstScreenState createState() => RegistrationFirstScreenState();
}

class RegistrationFirstScreenState extends State<RegistrationFirstScreen> {
  int kindOfSport = -1;
  DateTime? selectedDate;
  String? fromTime;
  String? toTime;

  WorkoutDataKeeper workoutDataKeeper = WorkoutDataKeeper();

  @override
  void initState() {
    super.initState();
    workoutDataKeeper.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration:
          screenDecoration("assets/registration_to_instructor/1_bg.png"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SelectKindOfSportWidget(this, kindOfSport),
              horizontalDivider(20, 20, 20, 20),
              DateWidget(this, selectedDate),
              horizontalDivider(20, 20, 20, 20),
            ],
          ),
          // TimeWidget(this),
          // _warningText(),
          Column(
            children: [
              _buttons(),
              Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text("ИЛИ",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey))),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: _selectCoachButton(),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Widget _warningText() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.02, left: 10, right: 10),
        child: const Text(
          "Укажите конкретное время или желаемый интервал для начала занятия",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.lightBlue),
        ));
  }

  Widget _continueButton() {
    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.08,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: _continueButtonBackgroundColor(),
        child: InkWell(
            onTap: (kindOfSport != -1 && selectedDate != null)
                ? _openNextScreen
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget _buttons() {
    return Container(
        margin: const EdgeInsets.only(top: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [_backButton(), _continueButton()],
        ));
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const MainScreen()),
            (route) => false);
      },
      child: const Icon(
        Icons.chevron_left,
        color: Colors.blue,
        size: 50,
      ),
    );
  }

  void _openNextScreen() {
    final DateTime now = selectedDate!;
    final DateFormat formatter = DateFormat('ddMMyyyy');
    final String formattedDate = formatter.format(now);
    workoutDataKeeper.date = formattedDate;
    workoutDataKeeper.id = selectedDate!.millisecond.toString() +
        selectedDate!.microsecond.toString();
    workoutDataKeeper.temporaryFrom = fromTime;
    workoutDataKeeper.to = toTime;
    workoutDataKeeper.sportType =
        kindOfSport == 0 ? SportType.skiing : SportType.snowboard;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => const InstructorsListScreen()));
  }

  Color _continueButtonBackgroundColor() {
    if (kindOfSport != -1 && selectedDate != null) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color _continueButtonTextColor() {
    if (kindOfSport != -1 && selectedDate != null) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  Widget _selectCoachButton() {
    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.08,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
          border: Border.all(color: _selectCoachButtonColor()),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Material(
        borderRadius: const BorderRadius.all(const Radius.circular(35)),
        color: Colors.transparent,
        child: InkWell(
            onTap: (kindOfSport != -1 && selectedDate == null)
                ? _openInstructorsListScreen
                : null,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _selectCoachText("выбрать определенного"),
                    _selectCoachText("инструктора")
                  ]),
            )),
      ),
    );
  }

  void _openInstructorsListScreen() {
    workoutDataKeeper.sportType =
        kindOfSport == 0 ? SportType.skiing : SportType.snowboard;
    workoutDataKeeper.from = fromTime;
    workoutDataKeeper.to = toTime;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => InstructorsListScreen()));
  }

  Widget _selectCoachText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: _selectCoachButtonColor(),
          fontSize: 16,
          fontWeight: FontWeight.normal),
    );
  }

  Color _selectCoachButtonColor() {
    if (kindOfSport == -1) {
      return Colors.grey;
    } else {
      return selectedDate == null ? Colors.blue : Colors.grey;
    }
  }
}
