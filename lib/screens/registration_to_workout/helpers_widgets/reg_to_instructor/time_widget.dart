import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../registration_first_screen.dart';

class TimeWidget extends StatefulWidget {
  final RegistrationFirstScreenState registrationFirstScreenState;

  const TimeWidget(this.registrationFirstScreenState, {Key? key})
      : super(key: key);

  @override
  _TimeWidgetState createState() => _TimeWidgetState();
}

class _TimeWidgetState extends State<TimeWidget> {
  String? _fromTime;
  String? _toTime;

  final List<String> times = [
    "любое",
    "09:00",
    "09:30",
    "10:00",
    "10:30",
    "11:00",
    "11:30",
    "12:00",
    "12:30",
    "13:00",
    "13:30",
    "14:00",
    "14:30",
    "15:00",
    "15:30",
    "16:00",
    "16:30",
    "17:00",
    "17:30",
    "18:00",
    "18:30",
    "19:00",
    "19:30",
    "20:00",
  ];

  @override
  Widget build(BuildContext context) {
    return _timeWidget();
  }

  Widget _timeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _timeNameWidget(),
        _timeField(20, 10, 1),
        const Text("-"),
        _timeField(10, 0, 2)
      ],
    );
  }

  Widget _timeNameWidget() {
    return Row(
      children: [
        Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: Image.asset("assets/registration_to_instructor/4_e4.png")),
        Container(
          margin: const EdgeInsets.only(right: 8),
          child: const Text(
            "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _timeField(double leftMargin, double rightMargin, int position) {
    return Container(
        width: screenWidth * 0.25,
        height: 30,
        padding: const EdgeInsets.only(left: 3),
        margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: position == 1 ? _fromTime : _toTime,
            items: times.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                if (position == 1) {
                  _fromTime = value;
                  widget.registrationFirstScreenState.fromTime = value;
                } else {
                  _toTime = value;
                  widget.registrationFirstScreenState.toTime = value;
                }
              });
            },
          ),
        ));
  }
}
