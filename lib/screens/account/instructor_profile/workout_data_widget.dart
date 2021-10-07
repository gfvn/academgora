import 'package:academ_gora_release/model/visitor.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../main.dart';
import '../../extension.dart';

class WorkoutDataWidget extends StatefulWidget {
  final Workout workout;

  const WorkoutDataWidget(this.workout, {Key? key}) : super(key: key);

  @override
  _WorkoutDataWidgetState createState() => _WorkoutDataWidgetState();
}

class _WorkoutDataWidgetState extends State<WorkoutDataWidget> {
  bool isExpanded = false;
  Icon _expandedIcon = Icon(Icons.keyboard_arrow_down);
  ExpandableController _expandableController = ExpandableController();

  @override
  Widget build(BuildContext context) {
    _setExpandedIconListener();
    return _workoutWidget();
  }

  Widget _workoutWidget() {
    return Container(
        child: ExpandablePanel(
      header: _header(),
      expanded: _body(),
      controller: _expandableController, collapsed: _body(),
    ));
  }

  Widget _header() {
    return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 6),
        height: 30,
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(
                  _parseDate(widget.workout.date!),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                  "${widget.workout.from}-${widget.workout.to}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )),
            Container(
                margin: EdgeInsets.only(left: screenWidth * 0.05),
                child: _expandedIcon)
          ],
        ));
  }

  Widget _body() {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        width: screenWidth * 0.6,
        decoration: BoxDecoration(color: Colors.white70),
        child: Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_parsePeopleNames()),
                GestureDetector(
                    onTap: () {
                      callNumber(widget.workout.userPhoneNumber!);
                    },
                    child: Text(widget.workout.userPhoneNumber!)),
                Text("Количество человек: ${widget.workout.peopleCount}"),
                Text("Возраст: ${_parsePeopleAges()}"),
                Text(
                    "Продолжительность: ${widget.workout.workoutDuration} час."),
                Text(
                    "Уровень катания: ${_parseLevelOfSkating(widget.workout.levelOfSkating!)}"),
              ],
            )));
  }

  String _parseDate(String date) {
    String formattedDate =
        "${date.substring(0, 2)}.${date.substring(2, 4)}.${date.substring(6, 8)}";
    return formattedDate;
  }

  String _parsePeopleNames() {
    List<Visitor> visitors = widget.workout.visitors;
    String peopleNames = '';
    for (var i = 0; i < visitors.length; ++i) {
      if (i != visitors.length - 1) {
        peopleNames += "${visitors[i].name}, ";
      } else {
        peopleNames += visitors[i].name;
      }
    }
    return peopleNames;
  }

  String _parsePeopleAges() {
    List<Visitor> visitors = widget.workout.visitors;
    String peopleAges = '';
    for (var i = 0; i < visitors.length; ++i) {
      if (i != visitors.length - 1) {
        peopleAges += "${visitors[i].age}, ";
      } else {
        peopleAges += "${visitors[i].age}";
      }
    }
    return peopleAges;
  }

  String _parseLevelOfSkating(int level) {
    switch (level) {
      case 0:
        return "С нуля";
        break;
      case 1:
        return "Немного умею";
        break;
      case 2:
        return "Умею с любой горы, улучшение техники";
        break;
      default:
        return "";
    }
  }

  void _setExpandedIconListener() {
    _expandableController.addListener(() {
      if (_expandableController.value) {
        setState(() {
          _expandedIcon = Icon(Icons.keyboard_arrow_up);
        });
      } else {
        setState(() {
          _expandedIcon = Icon(Icons.keyboard_arrow_down);
        });
      }
    });
  }
}