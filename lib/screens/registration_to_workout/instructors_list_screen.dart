import 'package:academ_gora_release/core/common/times_controller.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/reg_to_instructor_data.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/workout.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import 'package:intl/intl.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';
import 'helpers_widgets/instructor_list/instructor_widget.dart';
import 'registration_parameters_screen.dart';

class InstructorsListScreen extends StatefulWidget {
  const InstructorsListScreen({Key? key}) : super(key: key);

  @override
  InstructorsListScreenState createState() => InstructorsListScreenState();
}

class InstructorsListScreenState extends State<InstructorsListScreen> {
  List<Instructor> instructors = [];
  List<Instructor> reversedList = [];

  RegToInstructorData? regToInstructorData;
  final WorkoutDataKeeper _workoutSingleton = WorkoutDataKeeper();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final TimesController _timesController = TimesController();

  DateTime? _selectedDate;
  @override
  void initState() {
    _setSelectedDate();
    instructors = _instructorsKeeper
        .findInstructorsByKindOfSport(_workoutSingleton.sportType!);
    var radomInstructorList = makeInstructorListRandom(instructors);
    reversedList = radomInstructorList.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Инструкторы",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration:
            screenDecoration("assets/registration_to_instructor/1_bg.png"),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.74,
              margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
              child: ListView.builder(
                itemCount: reversedList.length,
                itemBuilder: (context, index) {
                  return _instructorWidget(
                    reversedList[index],
                    index,
                  );
                },
              ),
            ),
            _buttons()
          ],
        ),
      ),
    );
  }

  List<Instructor> makeInstructorListRandom(List<Instructor> list) {
    DateTime now = DateTime.now();
    list.shuffle();
    list.map((instructor) {
      List<String> _openedTimes = [];
      var daysSchedule = instructor.schedule;
      var timesPerDay =
          daysSchedule![DateFormat('ddMMyyyy').format(_selectedDate!)];
      if (timesPerDay != null) {
        timesPerDay.forEach(
          (key, value) {
            if (value == "открыто") {
              if (!_openedTimes.contains(value)) {
                DateTime time = DateTime(
                  _selectedDate!.year,
                  _selectedDate!.month,
                  _selectedDate!.day,
                  int.tryParse(key!.toString().substring(0, 2)) ?? 0,
                );
                if (time.isAfter(now)) {
                  _openedTimes.add(key);
                }
              }
            }
          },
        );
      }
      instructor.openedTimes = _filterOpenedTimes(_openedTimes);
      return instructor;
    }).toList();
    list.sort((a, b) => a.openedTimes!.length.compareTo(b.openedTimes!.length));
    return list;
  }

  List<String> _filterOpenedTimes(List<String> openedTimes) {
    List<String> filteredTimes = [];
    String? from = _workoutSingleton.temporaryFrom;
    String? to = _workoutSingleton.to;
    if ((from == null || from == 'любое') && (to == null || to == 'любое')) {
    } else if ((from != null && from != 'любое') &&
        (to == null || to == 'любое')) {
      var times = _timesController.times;
      int priorityFrom = times[from];
      for (var element in openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime >= priorityFrom) filteredTimes.add(element);
      }
      openedTimes = filteredTimes;
    } else if ((from == null || from == 'любое') &&
        (to != null && to != 'любое')) {
      var times = _timesController.times;
      int priorityTo = times[to];
      for (var element in openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime <= priorityTo) filteredTimes.add(element);
      }
      openedTimes = filteredTimes;
    } else {
      var times = _timesController.times;
      int priorityFrom = times[from];
      int priorityTo = times[to];
      for (var element in openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime >= priorityFrom &&
            priorityOpenedTime <= priorityTo) filteredTimes.add(element);
      }
      openedTimes = filteredTimes;
    }
    return openedTimes;
  }

  Widget _instructorWidget(Instructor instructor, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(
            width: 0.5,
            color: Colors.grey,
          ),
          top: index == 0
              ? const BorderSide(
                  width: 0.5,
                  color: Colors.grey,
                )
              : const BorderSide(
                  color: Colors.transparent,
                ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: InstructorWidget(instructor, this),
      ),
    );
  }

  Widget _buttons() {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // _backButton(),
            _continueButton(),
          ],
        ));
  }

  void _setSelectedDate() {
    if (_workoutSingleton.date != null && _workoutSingleton.date!.isNotEmpty) {
      String date = _workoutSingleton.date!;
      String formattedDate =
          "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
      DateTime dateTime = DateTime.parse(formattedDate);
      _selectedDate = dateTime;
    } else {
      _selectedDate = DateTime.now();
    }
  }

  Widget _continueButton() {
    return Center(
      child: SizedBox(
        width: screenWidth * 0.9,
        height: 50,
        // margin: const EdgeInsets.only(right: 20),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _continueButtonBackgroundColor() {
    if (regToInstructorData == null) {
      return Colors.white;
    } else {
      return kMainColor;
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
    workoutSingleton.instructorfcmToken = regToInstructorData!.fcomToken;
    workoutSingleton.from = regToInstructorData!.time;
    workoutSingleton.date ??=
        DateFormat('ddMMyyyy').format(regToInstructorData!.date);
    workoutSingleton.id ??=
        regToInstructorData!.date.millisecondsSinceEpoch.toString();
    workoutSingleton.instructorPhoneNumber = regToInstructorData!.phoneNumber;
    workoutSingleton.instructorId = _instructorsKeeper
        .findInstructorByPhoneNumber(regToInstructorData!.phoneNumber)!
        .id;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => const RegistrationParametersScreen()));
  }
}
