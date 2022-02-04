import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../main.dart';
import '../../registration_first_screen.dart';

class DateWidget extends StatefulWidget {
  final DateTime? _selectedDate;
  final RegistrationFirstScreenState registrationToInstructorScreenState;

  const DateWidget(this.registrationToInstructorScreenState, this._selectedDate,
      {Key? key})
      : super(key: key);

  @override
  _DateWidgetState createState() => _DateWidgetState(_selectedDate);
}

class _DateWidgetState extends State<DateWidget> {
  DateTime? _selectedDate;

  _DateWidgetState(this._selectedDate);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_dateNameWidget(), _dateFieldWidget()],
    );
  }

  Widget _dateNameWidget() {
    return Row(
      children: [
        Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: Image.asset("assets/registration_to_instructor/4_e3.png")),
        const Text(
          "ДАТА",
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _dateFieldWidget() {
    return Container(
      width: screenWidth * 0.5,
      height: 30,
      margin: EdgeInsets.only(left: screenWidth * 0.18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_dateTextWidget(), _clearDateWidget()]),
    );
  }

  Widget _dateTextWidget() {
    return GestureDetector(
      child: Center(
          child: Container(
              width: screenWidth * 0.4,
              alignment: Alignment.center,
              color: Colors.white,
              height: 30,
              child: Text(
                _selectedDate == null
                    ? ""
                    : DateFormat("dd.MM.yyyy").format(_selectedDate!),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ))),
      onTap: _showDateDialog,
    );
  }

  Widget _clearDateWidget() {
    return GestureDetector(
      child: Container(
          height: 13,
          width: 13,
          margin: const EdgeInsets.only(left: 5, right: 5),
          child: Image.asset("assets/registration_to_instructor/5_e8.png")),
      onTap: _clearDateFieldButton,
    );
  }

  void _clearDateFieldButton() {
    _selectedDate = null;
    WorkoutDataKeeper().date = null;
    widget.registrationToInstructorScreenState.setState(() {
      widget.registrationToInstructorScreenState.selectedDate = _selectedDate;
    });
    setState(() {});
  }

  Future<void> _showDateDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (c, setState) => AlertDialog(
            actions: [
              TextButton(
                  child: const Text('OK'), onPressed: _applyAndCloseDialog),
            ],
            content: CalendarCarousel<Event>(
              headerTextStyle: TextStyle(
                  fontSize: 20, color: Colors.blueAccent),
              locale: "ru",
              width: 300,
              height: 350,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              todayTextStyle: const TextStyle(color: Colors.blueAccent),
              onDayPressed: (DateTime date, List<Event> events) {
                DateTime now = DateTime.now();
                if (date.isAfter(now) || date.isSameDate(now)) {
                  setState(() {
                    {
                      DateTime newDateTime = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          now.hour,
                          now.minute,
                          now.second,
                          now.millisecond);
                      _selectedDate = newDateTime;
                    }
                  });
                }
              },
              selectedDateTime: _selectedDate,
              targetDateTime: _selectedDate,
              selectedDayTextStyle: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void _applyAndCloseDialog() {
    Navigator.of(context).pop();
    widget.registrationToInstructorScreenState.setState(() {
      widget.registrationToInstructorScreenState.selectedDate = _selectedDate!;
    });
    setState(() {});
  }
}
