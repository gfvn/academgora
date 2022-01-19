import 'dart:developer';

import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../../main.dart';

class InstructorDataWidget extends StatefulWidget {
  final Instructor instructor;
  final DateTime selectedDate;
  final bool isNeedCount;
  final bool isUpdate;


  const InstructorDataWidget(
    this.instructor, {
    Key? key,
    required this.selectedDate,
    required this.isNeedCount, required this.isUpdate,
  }) : super(key: key);

  @override
  _InstructorDataWidgetState createState() => _InstructorDataWidgetState();
}

class _InstructorDataWidgetState extends State<InstructorDataWidget> {
  bool isExpanded = false;
  int sum = 0;
  int onePrice = 0;
  int twoPrice = 0;
  int threePrice = 0;
  int fourPrice = 0;
  final ExpandableController _expandableController = ExpandableController();
  final PriceKeeper _priceDataKeeper = PriceKeeper();

  @override
  void initState() {
    _getPrice();
    super.initState();
  }

  Future<void> _getPrice() async {
    List<String> priceList = _priceDataKeeper.priceList;
    if (priceList.isNotEmpty) {
      onePrice = int.parse(priceList[0]);
      twoPrice = int.parse(priceList[1]);
      threePrice = int.parse(priceList[2]);
      fourPrice = int.parse(priceList[3]);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getPrice();
    return _instructorWidget();
  }

  Widget _instructorWidget() {
    return ExpandablePanel(
      header: _header(),
      expanded: _body(),
      controller: _expandableController,
      collapsed: Container(),
    );
  }

  Widget _header() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 6),
      height: 50,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 3, right: 5),
                  child: Text(
                    widget.instructor.name ?? "Имя Фамилия",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.instructor.phone ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
    );
  }

  Widget _body() {
    return widget.isUpdate? Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: screenWidth * 0.9,
      decoration: const BoxDecoration(color: Colors.white70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildWorkoutTable(),
          widget.isNeedCount
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16, left: 16, top: 8, bottom: 8),
                      child: Text(
                        "Итог дня: $sum",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    ):Container();
  }

  int getWorkoutPrice(int? number) {
    if (number == 1) {
      return onePrice;
    }
    if (number == 2) {

      return twoPrice;
    }
    if (number == 3) {

      return threePrice;
    }
    if (number == 4) {
      return fourPrice;
    }
    return 0;
  }

  void countWorkoutsPrice(List<Workout> workouts) {
    int summAllWorkout = 0;
    for (Workout workout in workouts) {
      int price = getWorkoutPrice(workout.peopleCount);
      summAllWorkout = summAllWorkout + workout.workoutDuration! * price;
    }
    setState(() {
      sum = summAllWorkout;
    });
  }

  Widget buildWorkoutTable() {
    final filteredDayWorkOut =
        _sortWorkoutsBySelectedDate(widget.instructor.workouts!);
    ///Count workouts price
    countWorkoutsPrice(filteredDayWorkOut);
    return filteredDayWorkOut.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(bottom: 10, right: 10),
            child: Table(
              border: TableBorder.all(color: Colors.black, width: 2),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(),
                3: FlexColumnWidth(3),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: List.generate(
                filteredDayWorkOut.length,
                (index) => _tableRow(
                  filteredDayWorkOut[index],
                ),
              ),
            ),
          )
        : Container(
            height: 10,
          );
  }


  TableRow _tableRow(Workout workout,
      {Color color = Colors.transparent, double leftPadding = 0}) {
    return TableRow(
      children: <Widget>[
        _textInTable(
          "${workout.from}",
        ),
        _textInTable(
          "${workout.peopleCount} человека",
        ),
        _textInTable(
          workout.workoutDuration == 1
              ? "${workout.workoutDuration} час"
              : "${workout.workoutDuration} часа",
        ),
        _textInTable(
          "${workout.userPhoneNumber}",
        ),
      ],
    );
  }

  Widget _textInTable(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 1, top: 5, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
      ),
    );
  }

  List<Workout> _sortWorkoutsBySelectedDate(List<Workout> list) {
    List<Workout> sortedWorkouts = [];
    if (list.isNotEmpty) {
      for (var workout in list) {
        String workoutDateString = workout.date!;
        String now = DateFormat('ddMMyyyy').format(widget.selectedDate);
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
}
