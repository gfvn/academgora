import 'package:academ_gora_release/core/data_keepers/filter_datakeeper.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:academ_gora_release/core/style/color.dart';

class DateWidget extends StatefulWidget {
  final DateTime? _selectedDate;
  final dynamic registrationToInstructorfilteredList;
  final String text;
  final bool isFirstdate;

  const DateWidget(
      this.registrationToInstructorfilteredList, this._selectedDate,
      {Key? key, required this.text, required this.isFirstdate})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DateWidgetState createState() => _DateWidgetState(_selectedDate);
}

class _DateWidgetState extends State<DateWidget> {
  DateTime? _selectedDate;
  final FilterKeeper _filterKeeper = FilterKeeper();

  _DateWidgetState(this._selectedDate);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_dateNameWidget(), _dateFieldWidget()],
    );
  }

  Widget _dateNameWidget() {
    return Row(
      children: [
        Text(
          widget.text.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _dateFieldWidget() {
    return Container(
      width: 130,
      height: 30,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_dateTextWidget(), _clearDateWidget()]),
    );
  }

  Widget _dateTextWidget() {
    return GestureDetector(
      child: Center(
        child: Container(
          width: 100,
          alignment: Alignment.center,
          color: Colors.white,
          height: 30,
          child: Text(
            _selectedDate == null
                ? ""
                : DateFormat("dd.MM.yyyy").format(_selectedDate!),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
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
    _selectedDate =
        widget.registrationToInstructorfilteredList.widget.choosedDateTime;
    if (widget.isFirstdate) {
      widget.registrationToInstructorfilteredList.setState(
        () {
          _filterKeeper.firstDate = _selectedDate!;

          widget.registrationToInstructorfilteredList.firstDate =
              _selectedDate!;
        },
      );
    } else {
      widget.registrationToInstructorfilteredList.setState(
        () {
          _filterKeeper.secondDate = _selectedDate!;
          widget.registrationToInstructorfilteredList.secondDate =
              _selectedDate!;
        },
      );
    }
    widget.registrationToInstructorfilteredList.setState(
      () {
        widget.registrationToInstructorfilteredList.firstDate = _selectedDate!;
      },
    );
    setState(
      () {},
    );
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
              headerTextStyle:
                  TextStyle(fontSize: screenHeight * 0.028, color: kMainColor),
              locale: "ru",
              width: 300,
              height: 270,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              todayTextStyle: const TextStyle(color: kMainColor),
              onDayPressed: (DateTime date, List<Event> events) {
                DateTime now = DateTime.now();
                if (true) {
                  setState(
                    () {
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
                    },
                  );
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
    widget.registrationToInstructorfilteredList.setState(() {
      if (widget.isFirstdate) {
        widget.registrationToInstructorfilteredList.firstDate = _selectedDate!;
        _filterKeeper.firstDate = _selectedDate!;
      } else {
        widget.registrationToInstructorfilteredList.secondDate = _selectedDate!;
        _filterKeeper.secondDate = _selectedDate!;
      }
    });
    setState(() {});
  }
}
