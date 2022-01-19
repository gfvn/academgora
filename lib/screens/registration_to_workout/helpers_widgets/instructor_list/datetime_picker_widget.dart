import 'dart:developer';

import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/reg_to_instructor_data.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../extension.dart';
import 'instructor_widget.dart';
import 'package:intl/intl.dart';

class DateTimePickerWidget extends StatefulWidget {
  final Instructor instructor;

  final InstructorWidgetState instructorWidgetState;

  const DateTimePickerWidget(this.instructorWidgetState,
      {Key? key, required this.instructor})
      : super(key: key);

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  RegToInstructorData? _regToInstructorDataCurrent;

  DateTime? _selectedDate;
  final WorkoutDataKeeper _workoutSingleton = WorkoutDataKeeper();

  List<String> _openedTimes = [];

  final TimesController _timesController = TimesController();

  @override
  void initState() {
    super.initState();
    _setSelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    _fillOpenedTimes();
    return _dateTimePickerWidget();
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

  Widget _dateTimePickerWidget() {
    return Column(
      children: [
        _dateSliderWidget(),
        _timeWidget(),
      ],
    );
  }

  Widget _dateSliderWidget() {
    return Container(
        margin: EdgeInsets.only(left: screenWidth * 0.08),
        child: Row(
          children: [
            GestureDetector(
              onTap: _decreaseDate,
              child: SizedBox(
                height: screenWidth * 0.09,
                width: screenWidth * 0.09,
                child: Image.asset("assets/instructors_list/e_6.png"),
              ),
            ),
            Container(
                width: screenWidth * 0.38,
                alignment: Alignment.center,
                child: Text(_getSelectedDate())),
            GestureDetector(
              onTap: _increaseDate,
              child: SizedBox(
                height: screenWidth * 0.09,
                width: screenWidth * 0.09,
                child: Image.asset("assets/instructors_list/e_7.png"),
              ),
            ),
          ],
        ));
  }

  String _getSelectedDate() {
    String month = months[_selectedDate!.month - 1];
    String weekday = weekdays[_selectedDate!.weekday - 1];
    return "${_selectedDate!.day} $month ($weekday)";
  }

  void _increaseDate() {
    setState(() {
      _selectedDate = _selectedDate!.add(const Duration(days: 1));
    });
  }

  void _decreaseDate() {
    if (_selectedDate!.month == DateTime.now().month &&
        _selectedDate!.day == DateTime.now().day) {
      return;
    } else {
      setState(() {
        _selectedDate = _selectedDate!.subtract(const Duration(days: 1));
      });
    }
  }

  Widget _timeWidget() {
    print("length ${_openedTimes.length}");
    return _openedTimes.isEmpty? const Padding(
      padding: EdgeInsets.only(top:16.0, bottom: 16),
      child: Center(child: Text("Нет доступного времени", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
    ):
     Container(
      margin: EdgeInsets.only(left: screenWidth * 0.1, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: _fillTimes(0, 4),
          ),
          Row(children: _fillTimes(4, 8)),
          Row(
            children: _fillTimes(8, 12),
          ),
          Row(
            children: _fillTimes(12, 16),
          ),
          Row(
            children: _fillTimes(16, 20),
          ),
          Row(
            children: _fillTimes(20, 23),
          ),
        ],
      ),
    );
  }

  void _fillOpenedTimes() {
    DateTime now = DateTime.now();
    _openedTimes = [];
    var daysSchedule = widget.instructor.schedule;
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
    _openedTimes = _timesController.sortTimes(_openedTimes);
    _filterOpenedTimes();
  }

  void _filterOpenedTimes() {
    List<String> filteredTimes = [];
    String? from = _workoutSingleton.temporaryFrom;
    String? to = _workoutSingleton.to;
    if ((from == null || from == 'любое') && (to == null || to == 'любое')) {
    } else if ((from != null && from != 'любое') &&
        (to == null || to == 'любое')) {
      var times = _timesController.times;
      int priorityFrom = times[from];
      for (var element in _openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime >= priorityFrom) filteredTimes.add(element);
      }
      _openedTimes = filteredTimes;
    } else if ((from == null || from == 'любое') &&
        (to != null && to != 'любое')) {
      var times = _timesController.times;
      int priorityTo = times[to];
      for (var element in _openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime <= priorityTo) filteredTimes.add(element);
      }
      _openedTimes = filteredTimes;
    } else {
      var times = _timesController.times;
      int priorityFrom = times[from];
      int priorityTo = times[to];
      for (var element in _openedTimes) {
        int priorityOpenedTime = times[element];
        if (priorityOpenedTime >= priorityFrom &&
            priorityOpenedTime <= priorityTo) filteredTimes.add(element);
      }
      _openedTimes = filteredTimes;
    }
  }

  List<Widget> _fillTimes(int from, int to) {
    List<Widget> timesWidgets = [];
    if (_openedTimes.length >= from) {
      int k;
      if (_openedTimes.length >= to) {
        k = to;
      } else {
        k = _openedTimes.length;
      }
      for (var i = from; i < k; ++i) {
        timesWidgets.add(_pickTimeButtonWidget(_openedTimes[i]));
      }
    }
    return timesWidgets;
  }

  Widget _pickTimeButtonWidget(String time) {
    return GestureDetector(
        onTap: () => _selectTime(time),
        child: Container(
          height: screenHeight * 0.05,
          width: screenWidth * 0.13,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: _getTimeButtonColor(time),
              border: Border.all(color: Colors.grey, width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(3))),
          child: Text(
            time,
            style: TextStyle(color: _getTimeTextColor(time)),
          ),
        ));
  }

  void _selectTime(String time) {
    _workoutSingleton.date = DateFormat("ddMMyyyy").format(_selectedDate!);
    RegToInstructorData regToInstructorData = RegToInstructorData(
        widget.instructorWidgetState.instructor!.name!,
        widget.instructorWidgetState.instructor!.phone!,
        _selectedDate!,
        time,
        widget.instructorWidgetState.instructor!.fcm_token!);
    if (widget.instructorWidgetState.regToInstructorData == null) {
      _updateRegToInstructorData(regToInstructorData);
    } else if (widget
            .instructorWidgetState.regToInstructorData!.instructorName ==
        regToInstructorData.instructorName) {
      _updateRegToInstructorData(regToInstructorData);
    } else {
      _updateRegToInstructorData(regToInstructorData);
    }
  }

  void _updateRegToInstructorData(RegToInstructorData regToInstructorData) {
    setState(() {
      if (_regToInstructorDataCurrent == regToInstructorData) {
        _regToInstructorDataCurrent = null;
      } else {
        _regToInstructorDataCurrent = regToInstructorData;
      }
    });
    widget.instructorWidgetState.setState(() {
      widget.instructorWidgetState.regToInstructorData =
          _regToInstructorDataCurrent;
    });
  }

  Color _getTimeButtonColor(String time) {
    if (widget.instructorWidgetState.regToInstructorData != null &&
        _regToInstructorDataCurrent != null &&
        widget.instructorWidgetState.regToInstructorData!.instructorName ==
            _regToInstructorDataCurrent!.instructorName &&
        _regToInstructorDataCurrent!.date == _selectedDate &&
        _regToInstructorDataCurrent!.time == time) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color _getTimeTextColor(String time) {
    if (widget.instructorWidgetState.regToInstructorData != null &&
        _regToInstructorDataCurrent != null &&
        widget.instructorWidgetState.regToInstructorData!.instructorName ==
            _regToInstructorDataCurrent!.instructorName &&
        _regToInstructorDataCurrent!.date == _selectedDate &&
        _regToInstructorDataCurrent!.time == time) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
