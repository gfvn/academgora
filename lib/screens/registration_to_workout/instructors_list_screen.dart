import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/reg_to_instructor_data.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../main.dart';
import '../extension.dart';
import 'helpers_widgets/instructor_list/instructor_widget.dart';
import 'registration_parameters_screen.dart';

class InstructorsListScreen extends StatefulWidget {
  const InstructorsListScreen({Key? key}) : super(key: key);

  @override
  InstructorsListScreenState createState() => InstructorsListScreenState();
}

class InstructorsListScreenState extends State<InstructorsListScreen> {
  List<Instructor> instructors = [];
  RegToInstructorData? regToInstructorData;
  final WorkoutDataKeeper _workoutSingleton = WorkoutDataKeeper();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  @override
  Widget build(BuildContext context) {
    instructors = _instructorsKeeper
        .findInstructorsByKindOfSport(_workoutSingleton.sportType!);
    return Scaffold(
      body: Container(
          decoration:
              screenDecoration("assets/registration_to_instructor/1_bg.png"),
          child: Column(children: [
            Container(
              height: screenHeight * 0.72,
              margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
              child: ListView.builder(
                itemCount: instructors.length,
                itemBuilder: (context, index) {
                  return _instructorWidget(instructors[index], index);
                },
              ),
            ),
            _buttons()
          ])),
    );
  }

  Widget _instructorWidget(Instructor instructor, int index) {
    return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: const BorderSide(width: 0.5, color: Colors.grey),
            top: index == 0
                ? const BorderSide(width: 0.5, color: Colors.grey)
                : const BorderSide(color: Colors.transparent),
          ),
        ),
        child: InstructorWidget(instructor, this));
  }

  Widget _buttons() {
    return Container(
        margin: const EdgeInsets.only(top: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_backButton(), _continueButton()],
        ));
  }

  Widget _backButton() {
    return GestureDetector(
      onTap: _onBackPressed,
      child: const Icon(
        Icons.chevron_left,
        color: Colors.blue,
        size: 50,
      ),
    );
  }

  Widget _continueButton() {
    return Container(
      width: 200,
      height: 55,
      margin: const EdgeInsets.only(right: 20),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: _continueButtonBackgroundColor(),
        child: InkWell(
            onTap:
                regToInstructorData == null ? null : _openRegParametersScreen,
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
                  ]),
            )),
      ),
    );
  }

  Color _continueButtonBackgroundColor() {
    if (regToInstructorData == null) {
      return Colors.white;
    } else {
      return Colors.blue;
    }
  }

  Color _continueButtonTextColor() {
    return regToInstructorData == null ? Colors.grey : Colors.white;
  }

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  void _openRegParametersScreen() {
    WorkoutDataKeeper workoutSingleton = WorkoutDataKeeper();
    workoutSingleton.instructorName = regToInstructorData!.instructorName;
    workoutSingleton.from = regToInstructorData!.time;
    workoutSingleton.date ??=
        DateFormat('ddMMyyyy').format(regToInstructorData!.date);
    workoutSingleton.id ??=
        regToInstructorData!.date.millisecondsSinceEpoch.toString();
    workoutSingleton.instructorPhoneNumber = regToInstructorData!.phoneNumber;
    workoutSingleton.instructorId = _instructorsKeeper
        .findInstructorByPhoneNumber(regToInstructorData!.phoneNumber)!
        .id;
    Navigator.of(context).push(
        MaterialPageRoute(builder: (c) => const RegistrationParametersScreen()));
  }
}
