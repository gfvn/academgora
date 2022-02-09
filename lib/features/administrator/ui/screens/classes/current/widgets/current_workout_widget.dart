// ignore_for_file: unused_element

import 'package:academ_gora_release/core/common/times_controller.dart';
import 'package:academ_gora_release/core/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';
import 'package:academ_gora_release/main.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentWorkoutWidget extends StatefulWidget {
  final Instructor instructor;
  final DateTime selectedDate;
  final bool isUpdate;
  final ExpandableController expandedController;

  const CurrentWorkoutWidget(
    this.instructor, {
    Key? key,
    required this.selectedDate,
    required this.isUpdate,
    required this.expandedController,
  }) : super(key: key);

  @override
  _CurrentWorkoutWidgetState createState() => _CurrentWorkoutWidgetState();
}

class _CurrentWorkoutWidgetState extends State<CurrentWorkoutWidget> {
  bool isExpanded = false;
  final PriceKeeper _priceDataKeeper = PriceKeeper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _instructorWidget();
  }

  Widget _instructorWidget() {
    final filteredDayWorkOut =
        _defineCurrentWorkout(widget.instructor.workouts!);
    return filteredDayWorkOut != null
        ? ExpandablePanel(
            header: _header(filteredDayWorkOut),
            expanded: _body(filteredDayWorkOut),
            controller: widget.expandedController,
            collapsed: Container(),
          )
        : Container();
  }

  Widget _header(Workout workout) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 6),
      height: 80,
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
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 3, right: 5),
                  child: Text(
                    workout.from.toString() + " - " + workout.to.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.instructor.kindOfSport ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
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

  Widget _body(Workout workout) {
    return widget.isUpdate
        ? Container(
            margin: const EdgeInsets.only(bottom: 5),
            width: screenWidth * 0.9,
            decoration: const BoxDecoration(color: Colors.white70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildWorkoutTable(workout),
              ],
            ),
          )
        : Container();
  }

  // int getWorkoutPrice(int? number) {
  //   if (number == 1) {
  //     return onePrice;
  //   }
  //   if (number == 2) {
  //     return twoPrice;
  //   }
  //   if (number == 3) {
  //     return threePrice;
  //   }
  //   if (number == 4) {
  //     return fourPrice;
  //   }
  //   return 0;
  // }

  // void countWorkoutsPrice(List<Workout> workouts) {
  //   int summAllWorkout = 0;
  //   for (Workout workout in workouts) {
  //     int price = getWorkoutPrice(workout.peopleCount);
  //     summAllWorkout = summAllWorkout + workout.workoutDuration! * price;
  //   }
  //   setState(() {
  //     sum = summAllWorkout;
  //   });
  // }

  Widget buildWorkoutTable(Workout workout) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Продожительность: ", ),
            Text(workout.workoutDuration.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Телефон клиента: "),
            Text(workout.userPhoneNumber.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Количество: "),
            Text(workout.peopleCount.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Уровень катания: "),
            Text(workout.levelOfSkating.toString())
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Комментарий: "),
            Text(workout.comment.toString())
          ],
        ),
      ],
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

  Workout? _defineCurrentWorkout(List<Workout> list) {
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

  Workout? _sortWorkoutsByTime(List<Workout> list) {
    Workout? workout;
    DateTime nowTime = DateTime.now();
    DateTime startingTime = DateTime.now();
    DateTime endingWorkoutTime = DateTime.now();
    if (list.isNotEmpty) {
      for (var workout in list) {
        startingTime = DateTime(nowTime.year, nowTime.month, nowTime.day,
            int.parse(workout.from!.substring(0, 2)));
        endingWorkoutTime = startingTime.add(
          Duration(hours: workout.workoutDuration!),
        );
        if (nowTime.isAfter(startingTime) &&
            nowTime.isBefore(endingWorkoutTime)) {
          return workout;
        }
      }
      return list[0];
    }
    return workout;
  }
}
