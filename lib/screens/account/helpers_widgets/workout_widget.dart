import 'package:academ_gora_release/controller/firebase_requests_controller.dart';
import 'package:academ_gora_release/controller/times_controller.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/account/helpers_widgets/workout_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../extension.dart';
import '../update_workout_screen.dart';
import '../user_profile/presentation/user_account_screen.dart';

class WorkoutWidget extends StatefulWidget {
  final Workout workout;
  final UserAccountScreenState userAccountScreenState;

  const WorkoutWidget(
      {Key? key, required this.workout, required this.userAccountScreenState})
      : super(key: key);

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  final TimesController _timesController = TimesController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  Instructor? _instructor;

  @override
  Widget build(BuildContext context) {
    _instructor = _instructorsKeeper
        .findInstructorByPhoneNumber(widget.workout.instructorPhoneNumber!);
    return Container(
      width: screenWidth * 0.9,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/account/e2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(children: [
        _titleRow(),
        _countOfPeople(),
        _redactButtons(),
        _infoTextColumn(),
        _instructorInfoWidget(),
        _callToInstructorButtons()
      ]),
    );
  }

  Widget _titleRow() {
    return Container(
        color: Colors.blue,
        height: 40,
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  _parseDate(widget.workout.date!),
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                )),
            Container(
                margin: EdgeInsets.only(left: screenWidth / 7),
                child: Text("${widget.workout.from}-${widget.workout.to}",
                    style: const TextStyle(color: Colors.white, fontSize: 22)))
          ],
        ));
  }

  String _parseDate(String date) {
    return "${date.substring(0, 2)}.${date.substring(2, 4)}.${date.substring(4, 8)}";
  }

  Widget _countOfPeople() {
    return Container(
        margin: const EdgeInsets.only(top: 15),
        child: Row(
          children: [
            Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Количество человек",
                  style: TextStyle(fontSize: 18),
                )),
            Container(
              margin: EdgeInsets.only(left: screenWidth / 6),
              child: Text(widget.workout.peopleCount.toString(),
                  style: const TextStyle(fontSize: 18)),
            ),
          ],
        ));
  }

  Widget _redactButtons() {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            _button("РЕДАКТИРОВАТЬ", 10, _openUpdateWorkoutScreen),
            _button("ОТМЕНИТЬ", screenWidth / 8, _showCancelWorkoutDialog),
          ],
        ));
  }

  void _openUpdateWorkoutScreen() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (c) => UpdateWorkoutScreen(widget.workout)));
  }

  Widget _button(String text, double leftMargin, Function function) {
    return GestureDetector(
      onTap: () {
        function.call();
      },
      child: Container(
        alignment: Alignment.center,
        height: 30,
        padding: const EdgeInsets.all(5),
        margin: EdgeInsets.only(left: leftMargin),
        decoration: const BoxDecoration(color: Colors.blue),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _showCancelWorkoutDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Отменить занятие?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Да',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: (){
                _cancelWorkout();
                Navigator.of(context).pop();
                },
            ),
            TextButton(
              child: const Text('Нет', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _cancelWorkout() {
    _deleteWorkoutFromUser();
  }

  void _deleteWorkoutFromUser() {
    UserRole.getUserRole().then((userRole) {
      if (userRole == UserRole.user) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        _firebaseRequestsController
            .delete("$userRole/$userId/Занятия/${widget.workout.id}")
            .then((_) {
          widget.userAccountScreenState.setState(() {});
        });
      }
    }).then((value) => _deleteWorkoutFromInstructor());
  }

  void _deleteWorkoutFromInstructor() {
    _firebaseRequestsController
        .delete(
            "${UserRole.instructor}/${_instructor!.id}/Занятия/Занятие ${widget.workout.id}")
        .then((_) {
      _firebaseRequestsController
          .update(
              "${UserRole.instructor}/${_instructor!.id}/График работы/${widget.workout.date}",
              _timesController.setTimesStatus(widget.workout.from!,
                  widget.workout.workoutDuration!, "не открыто"));
    });
  }

  Widget _infoTextColumn() {
    return Container(
        margin: const EdgeInsets.only(top: 8, left: 10),
        child: _infoText(WorkoutInfo.getWorkoutInfo()));
  }

  Widget _infoText(String text) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 11),
        ));
  }

  Widget _instructorInfoWidget() {
    return Container(
        width: screenWidth * 0.9,
        margin: const EdgeInsets.only(left: 10, top: 5),
        child: Row(
          children: [
            Text(
              "Инструктор:\n(${widget.workout.sportType})",
              style: const TextStyle(fontSize: 14),
            ),
            Container(
                width: screenWidth * 0.4,
                margin: const EdgeInsets.only(left: 45),
                child: Text(
                  _instructor!.name!,
                  style: TextStyle(fontSize: 14),
                )),
          ],
        ));
  }

  Widget _callToInstructorButtons() {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 10, bottom: 5),
      child: Row(children: [_phoneNumberButton(), _whatsAppButton()]),
    );
  }

  Widget _phoneNumberButton() {
    return GestureDetector(
        onTap: () {
          callNumber(widget.workout.instructorPhoneNumber!);
        },
        child: Container(
            alignment: Alignment.center,
            height: 30,
            width: screenWidth * 0.45,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/account/phone.png"),
              ),
            ),
            child: Text(
              widget.workout.instructorPhoneNumber!,
              style: TextStyle(color: Colors.white, fontSize: 12),
            )));
  }

  Widget _whatsAppButton() {
    return GestureDetector(
        onTap: () {
          launchURL(whatsAppUrl(widget.workout.instructorPhoneNumber!));
        },
        child: Container(
            alignment: Alignment.center,
            height: 30,
            width: screenWidth * 0.35,
            margin: EdgeInsets.only(left: screenWidth * 0.05),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              image: DecorationImage(
                image: AssetImage("assets/account/wa.png"),
              ),
            ),
            child: const Text(
              "Написать",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )));
  }
}
