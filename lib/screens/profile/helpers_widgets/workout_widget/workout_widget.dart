import 'package:academ_gora_release/core/style/color.dart';

import 'package:academ_gora_release/core/data_keepers/admin_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/notification_api.dart';
import 'package:academ_gora_release/features/administrator/domain/enteties/administrator.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../core/consants/extension.dart';
import '../../update_workout_screen.dart';
import '../workout_info.dart';
import 'cancel_workout.dart';
import 'cancel_workout_impl.dart';

class WorkoutWidget extends StatefulWidget {
  final Workout workout;

  const WorkoutWidget({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutWidgetState createState() => _WorkoutWidgetState();
}

class _WorkoutWidgetState extends State<WorkoutWidget> {
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  Instructor? _instructor;
  late CancelWorkout _cancelWorkout;
  final AdminKeeper _adminKeeper = AdminKeeper();
  List<Adminstrator> adminlist = [];
  List<Adminstrator> filteredAdminList = [];
  @override
  void initState() {
    super.initState();
    _getAdmins();
    filteredAdminList = adminlist;
    _instructor = _instructorsKeeper
        .findInstructorByPhoneNumber(widget.workout.instructorPhoneNumber!);
    _cancelWorkout = CancelWorkoutImplementation(_instructor!);
  }

  void _getAdmins() {
    adminlist = _adminKeeper.getAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/profile/e2.png"),
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
        color: kMainColor,
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
        decoration: const BoxDecoration(color: kMainColor),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void sendNotifications() {
    if (widget.workout.instructorFcmToken!.isNotEmpty) {
      String formattedDate =
          "${widget.workout.date!.substring(4, 8)}-${widget.workout.date!.substring(2, 4)}-${widget.workout.date!.substring(0, 2)}";
      NotificationService().sendNotificationToFcm(
        fcmToken: widget.workout.instructorFcmToken!,
        tittle: "Запись отменена",
        body:
            "Клиент отменил занятие на $formattedDate, ${widget.workout.from},",
      );
    }

    for (Adminstrator admin in filteredAdminList) {
      if (admin.fcmToken != null && admin.fcmToken!.isNotEmpty) {
        NotificationService().sendNotificationToFcm(
          fcmToken: admin.fcmToken.toString(),
          tittle: "Отмена занятия",
          body: "Инструктор отменил занятие, пожалуйста, утвердите!,",
        );
      }
    }
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
              onPressed: () {
                sendNotifications();
                _cancelWorkout.cancelWorkout(widget.workout);
                NotificationService().cancelNotificationLocal(
                  int.parse(
                    widget.workout.id.toString(),
                  ),
                );
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
                  _instructor!.name ?? "",
                  style: const TextStyle(fontSize: 14),
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
                image: AssetImage("assets/profile/phone.png"),
              ),
            ),
            child: Text(
              widget.workout.instructorPhoneNumber!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
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
                image: AssetImage("assets/profile/wa.png"),
              ),
            ),
            child: const Text(
              "Написать",
              style: TextStyle(color: Colors.white, fontSize: 12),
            )));
  }
}
