import 'dart:developer';

import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/common/times_controller.dart';
import 'package:academ_gora_release/core/data_keepers/filter_datakeeper.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/classes/current/widgets/current_workout_widget.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/help_screens/filter_screens.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:expandable/expandable.dart';

class CurrentScreen extends StatefulWidget {
  const CurrentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CurrentScreen> createState() => CurrentScreenState();
}

class CurrentScreenState extends State<CurrentScreen> {
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final ExpandableController _expandableController = ExpandableController();
  final FilterKeeper _filterKeeper = FilterKeeper();

  TextEditingController onePeopleController = TextEditingController();
  TextEditingController twoPeopleController = TextEditingController();
  TextEditingController threePeopleController = TextEditingController();
  TextEditingController fourPeopleController = TextEditingController();
  List<Instructor> instructorlist = [];
  List<Instructor> filteredInstructorList = [];
  List<Workout> currentWorkouts = [];
  List<DateTime> listOfDates = [];
  DateTime firstDate = DateTime.now().subtract(Duration(days: 1));
  DateTime secondDate = DateTime.now().subtract(Duration(days: 1));
  bool isUpdate = true;
  bool showAllInstructors = true;

  @override
  void initState() {
    updateDatas();
    super.initState();
  }

  @override
  void dispose() {
    _filterKeeper.clearfilter();
    super.dispose();
  }

  void updateDatas() {
    log("im updates");
    setState(() {
      _getInstructors();
      // firstDate = _filterKeeper.firstDate;
      secondDate = _filterKeeper.secondDate;
    });
  }

  void _getInstructors() {
    instructorlist = _filterKeeper.filteredInstructorList;
  }

  Future<void> update() async {
    await _firebaseController.get('Инструкторы').then(
      (value) {
        _instructorsKeeper.updateInstructors(value);
      },
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(
      () {
        isUpdate = true;
        _getInstructors();
      },
    );
  }

  bool isOneDay() {
    return firstDate == secondDate;
  }

  List<Workout> _sortWorkoutsBySelectedDate(
      List<Workout> list, DateTime selectedDate) {
    List<Workout> sortedWorkouts = [];
    if (list.isNotEmpty) {
      for (var workout in list) {
        String workoutDateString = workout.date!;
        String now = DateFormat('ddMMyyyy').format(selectedDate);
        if (now == workoutDateString) sortedWorkouts.add(workout);
      }
    }
    return _sortWorkoutsByTime(sortedWorkouts);
  }

  List<Workout> _sortWorkoutsByTime(List<Workout> list) {
    TimesController timesController = TimesController();
    if (list.isNotEmpty) {
      list.sort((first, second) {
        return timesController.times[first.from] -
            timesController.times[second.from];
      });
    }
    return list;
  }

  void updateListOfDates() {
    setState(() {
      listOfDates = getDaysInBetween(firstDate, secondDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    updateListOfDates();
    _getInstructors();
    // _getAllPrices();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Текущее",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => const FilterScreen(
                    fromCurrent: true,
                  ),
                ),
              );
              updateDatas();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.filter_alt_rounded,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: update,
          child: Container(
            height: screenHeight,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white70),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 0, right: 20, left: 20),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      _myRegistrationsTitle(text: "Инструкторы"),
                      Positioned(
                        right: 10,
                        bottom: 5,
                        child: InkWell(
                          onTap: () => setState(
                            () {
                              showAllInstructors = !showAllInstructors;
                              _expandableController.toggle();
                            },
                          ),
                          child: Container(
                            decoration: const BoxDecoration(),
                            height: 40,
                            width: 40,
                            child: showAllInstructors
                                ? const Icon(
                                    Icons.arrow_drop_down,
                                    size: 32,
                                  )
                                : const Icon(
                                    Icons.arrow_drop_up,
                                    size: 32,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                  isOneDay()
                      ? oneDayIsntructor(firstDate)
                      : manyDaysInstructor()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget oneDayIsntructor(DateTime time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _instructorListWidget(time),
      ],
    );
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Widget manyDaysInstructor() {
    updateListOfDates();
    return Column(
      children: [
        Column(
          children: List.generate(
            listOfDates.length,
            (index) {
              return buildManyInstructorItem(
                listOfDates[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildManyInstructorItem(DateTime time) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _titleWidget(
            _getSelectedDate(time),
          ),
        ),
        oneDayIsntructor(time),
      ],
    );
  }

  String _getSelectedDate(DateTime time) {
    String month = months[time.month - 1];
    String weekday = weekdays[time.weekday - 1];
    return "${time.day} $month ($weekday)";
  }

  Widget _instructorListWidget(DateTime selectedDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 8, left: 8),
      child: Column(
        children: List.generate(instructorlist.length, (index) {
          return CurrentWorkoutWidget(
            instructorlist[index],
            selectedDate: selectedDate,
            isUpdate: isUpdate,
            expandedController: _expandableController,
          );
        }),
      ),
    );
  }

  Widget buildInstructionText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text("Стоимость занятия при n количество человек"),
    );
  }

  Widget _titleWidget(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: Text(
        text + ' ${firstDate.hour} : ${firstDate.minute}',
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _myRegistrationsTitle({required String text}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 16, bottom: 16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
