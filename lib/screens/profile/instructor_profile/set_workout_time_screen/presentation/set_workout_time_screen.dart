import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/model/administrator.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/extension.dart' as extensions;
import 'package:academ_gora_release/screens/extension.dart';
import 'package:academ_gora_release/screens/registration_to_workout/helpers_widgets/horizontal_divider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';

import '../../../../../data_keepers/admin_keeper.dart';
import '../../../../../data_keepers/notification_api.dart';
import '../../../../../main.dart';
import 'instructor_data_view_model.dart';
import 'instructor_data_view_model_impl.dart';

class SetWorkoutTimeScreen extends StatefulWidget {
  final String? phoneNumber;
  final DateTime? selectedDateFrom;
  final String? time;
  final String? status;

  const SetWorkoutTimeScreen(
      {Key? key,
      this.phoneNumber,
      this.selectedDateFrom,
      this.time,
      this.status})
      : super(key: key);

  @override
  _SetWorkoutTimeScreenState createState() => _SetWorkoutTimeScreenState();
}

class _SetWorkoutTimeScreenState extends State<SetWorkoutTimeScreen> {
  final InstructorDataViewModel _instructorDataViewModel =
      InstructorDataViewModelImpl();

  DateTime _selectedDate = DateTime.now();

  List<String> _openedTimesPerDay = [];
  List<String> _closedTimesPerDay = [];
  List<String> _notAvailableTimesPerDay = [];
  List<Adminstrator> adminlist = [];
  List<Adminstrator> filteredAdminList = [];
  final AdminKeeper _adminKeeper = AdminKeeper();

  final EventList<Event> _markedDateMap = EventList<Event>(events: {});

  String? _selectedTimeStatus;

  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  final TimesController _timesController = TimesController();
  List<Workout> _workoutsPerDay = [];
  Instructor? _currentInstructor;

  @override
  void initState() {
    _getAdmins();
    if (widget.status != null) {
      _selectedTimeStatus = widget.status;
    }
    filteredAdminList = adminlist;
    if (widget.selectedDateFrom != null) {
      _selectedDate = widget.selectedDateFrom ?? DateTime.now();
    }
    super.initState();
    _instructorDataViewModel.getInstructorData(widget.phoneNumber);
  }

  void _getAdmins() {
    adminlist = _adminKeeper.getAllPersons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(alignment: Alignment.center, child: _body()));
  }

  Widget _body() {
    return StreamBuilder(
      stream: _instructorDataViewModel.instructorData,
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return Container();
        } else {
          _currentInstructor = snap.data as Instructor;
          _getOpenedTimesPerDay();
          _getOpenedTimesPerMonth();
          _getAllWorkoutsPerDay();
          return Column(
            children: [
              _titleRow(),
              horizontalDivider(screenWidth * 0.1, screenWidth * 0.1, 10, 10),
              _calendar(),
              _indicatorsRow(),
              horizontalDivider(screenWidth * 0.1, screenWidth * 0.1, 15, 15),
              _dateTimePickerWidget(),
              _changeStatusButtons()
            ],
          );
        }
      },
    );
  }

  Widget _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _backButton(),
        _instructorName(),
      ],
    );
  }

  Widget _backButton() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
            margin:
                EdgeInsets.only(left: 10, right: 20, top: screenHeight * 0.07),
            child: Row(
              children: const [Icon(Icons.arrow_back_ios), Text("НАЗАД")],
            )));
  }

  Widget _instructorName() {
    return Container(
        margin: EdgeInsets.only(top: screenHeight * 0.07),
        child: Text(
          _currentInstructor!.name ?? "имя",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ));
  }

  Widget workoutTime() {
    return Text(
      widget.time ?? "",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    );
  }

  Widget _calendar() {
    return CalendarCarousel<Event>(
      locale: "ru",
      width: screenWidth * 0.69,
      height: screenHeight * 0.38,
      selectedDayButtonColor: Colors.blue,
      headerMargin: const EdgeInsets.all(0),
      headerTextStyle:
          TextStyle(fontSize: screenHeight * 0.023, color: Colors.blue),
      weekdayTextStyle: const TextStyle(color: Colors.black),
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      todayTextStyle: const TextStyle(color: Colors.black),
      onDayPressed: (DateTime date, List<Event> events) {
        if (date.isAfter(DateTime.now()) || date.isSameDate(DateTime.now())) {
          setState(() {
            _selectedDate = date;
            _getOpenedTimesPerDay();
            _getOpenedTimesPerMonth();
            _getAllWorkoutsPerDay();
          });
        }
      },
      markedDatesMap: _markedDateMap,
      weekendTextStyle: const TextStyle(color: Colors.black),
      selectedDateTime: _selectedDate,
      targetDateTime: _selectedDate,
      selectedDayTextStyle: const TextStyle(color: Colors.white),
      markedDateShowIcon: true,
      markedDateIconBuilder: (e) => e.icon,
    );
  }

  Widget _indicatorsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _indicator("запись открыта", "assets/instructor_set_time/e5.png"),
        _indicator("записи нет", "assets/instructor_set_time/e6.png"),
      ],
    );
  }

  Widget _indicator(String text, String iconPath) {
    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(iconPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          )
        ],
      ),
    );
  }

  Widget _dateTimePickerWidget() {
    return Column(
      children: [_dateSliderWidget(), workoutTime(), _timesWidget()],
    );
  }

  Widget _dateSliderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _decreaseDate,
          child: SizedBox(
            height: screenWidth * 0.06,
            width: screenWidth * 0.06,
            child: Image.asset("assets/instructors_list/e_6.png"),
          ),
        ),
        Container(
            width: screenWidth * 0.38,
            alignment: Alignment.center,
            child: Text(
              _getSelectedDate(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
        GestureDetector(
          onTap: _increaseDate,
          child: SizedBox(
            height: screenWidth * 0.06,
            width: screenWidth * 0.06,
            child: Image.asset("assets/instructors_list/e_7.png"),
          ),
        ),
      ],
    );
  }

  String _getSelectedDate() {
    return "${_selectedDate.day} ${extensions.months[_selectedDate.month - 1]}";
  }

  void _increaseDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _getOpenedTimesPerDay();
    _getOpenedTimesPerMonth();
    _getAllWorkoutsPerDay();
  }

  void _decreaseDate() {
    if (_selectedDate.isAfter(DateTime.now())) {
      setState(() {
        _selectedDate = _selectedDate.subtract(const Duration(days: 1));
        _openedTimesPerDay = [];
        _closedTimesPerDay = [];
        _notAvailableTimesPerDay = [];
      });
      _getOpenedTimesPerDay();
      _getOpenedTimesPerMonth();
      _getAllWorkoutsPerDay();
    }
  }

  Widget _timesWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickTimeButtonWidget("09:00"),
              _pickTimeButtonWidget("09:30"),
              _pickTimeButtonWidget("10:00"),
              _pickTimeButtonWidget("10:30"),
              _pickTimeButtonWidget("11:00"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickTimeButtonWidget("11:30"),
              _pickTimeButtonWidget("12:00"),
              _pickTimeButtonWidget("12:30"),
              _pickTimeButtonWidget("13:00"),
              _pickTimeButtonWidget("13:30"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickTimeButtonWidget("14:00"),
              _pickTimeButtonWidget("14:30"),
              _pickTimeButtonWidget("15:00"),
              _pickTimeButtonWidget("15:30"),
              _pickTimeButtonWidget("16:00"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickTimeButtonWidget("16:30"),
              _pickTimeButtonWidget("17:00"),
              _pickTimeButtonWidget("17:30"),
              _pickTimeButtonWidget("18:00"),
              _pickTimeButtonWidget("18:30"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pickTimeButtonWidget("19:00"),
              _pickTimeButtonWidget("19:30"),
              _pickTimeButtonWidget("20:00"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _pickTimeButtonWidget(String time) {
    return GestureDetector(
        onTap: () => _selectTime(time),
        child: Container(
          height: screenHeight * 0.033,
          width: screenWidth * 0.15,
          alignment: Alignment.center,
          margin: EdgeInsets.all(screenHeight * 0.004),
          decoration: BoxDecoration(
              color: _getTimeButtonColor(time),
              border: Border.all(color: _getTimeTextColor(time), width: 0.5),
              borderRadius: const BorderRadius.all(Radius.circular(3))),
          child: Text(
            time,
            style: TextStyle(color: _getTimeTextColor(time), fontSize: 12),
          ),
        ));
  }

  void _selectTime(String time) async {
    if (_selectedTimeStatus != null) {
      _setSelectedView(time);
    }
  }

  void _setSelectedView(String time) {
    UserRole.getUserRole().then((userRole) {
      DateTime now = DateTime.now();
      if (_selectedDate.isAfterDate(now) || _selectedDate.isSameDate(now)) {
        setState(() {
          if (_selectedTimeStatus == TimeStatus.OPENED) {
            _sendOnce(time, "открыто");
          } else if (_selectedTimeStatus == TimeStatus.NOT_AVAILABLE) {
            if (userRole == UserRole.instructor) {
              showCancelDialog(context, () {
                _sendOnce(time, "недоступно");
                Navigator.pop(context);
              });
            } else {
              _sendOnce(time, "недоступно");
            }

            // _sendOnce(time, "недоступно");
          } else if (_selectedTimeStatus == TimeStatus.NOT_OPENED) {
            _sendOnce(time, "не открыто");
          }
        });
      }
    });
  }

  void _sendNotificationsForAdmins() {
    for (Adminstrator admin in filteredAdminList) {
      if (admin.fcm_token != null && admin.fcm_token!.isNotEmpty) {
        NotificationService().sendNotificationToFcm(
          fcmToken: admin.fcm_token.toString(),
          tittle: "Отмена занятия",
          body: "Инструктор отменил занятие, пожалуйста, утвердите!",
        );
      }
    }
  }

  void _createCancelOnDB(String time, String status) {
    print("здесььььььь");
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String dateString = DateFormat('ddMMyyyy').format(_selectedDate);
    _firebaseController.update(
      "Отмена/$userId$dateString$time",
      {
        "workout_id": userId + dateString + time,
        "workout_sportType": _currentInstructor?.kindOfSport,
        "date": dateString,
        "time": time,
        "instructor_name": _currentInstructor?.name,
        "instructor_fcm_token": _currentInstructor?.fcm_token,
        "instructor_phone": _currentInstructor?.phone,
        "status": status,
        "неок": 'ok'
      },
    );
  }

  void _sendOnce(String time, String status) async {
    UserRole.getUserRole().then(
      (userRole) {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        String dateString = DateFormat('ddMMyyyy').format(_selectedDate);
        if (userRole == UserRole.instructor) {
          if (_checkChangeTimePossibility(time)) {
            _firebaseController.update(
                "$userRole/$userId/График работы/$dateString",
                {time: status}).then((value) => setState(() {}));

            if (status == "открыто") {
              _firebaseController.update(
                "Log/Instructors",
                {
                  DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
                      instructorOpenWorkout(
                          _currentInstructor?.name ?? "", dateString, time)
                },
              );
            } else if (status == "недоступно" || status == "не открыто") {
              _firebaseController.update(
                "Log/Instructors",
                {
                  DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
                      instructorCloseWorkout(
                          _currentInstructor?.name ?? "", dateString, time)
                },
              );
            }
          } else {
            _createCancelOnDB(time, status);
            _sendNotificationsForAdmins();
            _showWarningCancelDialog(dateString, time);
          }
        }
        if (userRole == UserRole.administrator) {
          _showWarningChangeTimeDialogForAdmin(() {
            _firebaseController.update(
                "${UserRole.instructor}/${_currentInstructor!.id}/График работы/$dateString",
                {time: status}).then((value) {
              print("herererer");
              if (!_checkChangeTimePossibility(time)) {
                _deleteWorkout(time);
              }
            });
            if (status == "открыто") {
              _firebaseController.update(
                "Log/Adminstrator",
                {
                  DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
                      adminOpenWorkout(
                          "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                          _currentInstructor?.name ?? "",
                          dateString,
                          time)
                },
              );
            } else if (status == "недоступно" || status == "не открыто") {
              _firebaseController.update(
                "Log/Adminstrator",
                {
                  DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
                      adminCancelWorkout(
                          "${FirebaseAuth.instance.currentUser!.phoneNumber}",
                          _currentInstructor?.name ?? "",
                          dateString,
                          time)
                },
              );
            }
          });
        }
      },
    );
  }

  void _deleteWorkout(String time) {
    print("delete workout with admin");
    String workoutId = "";
    if (_workoutsPerDay.isNotEmpty) {
      for (var element in _workoutsPerDay) {
        if (_timesController.checkTimeInterval(
            time, element.from!, element.to!)) {
          print("${element.userPhoneNumber!}");
          workoutId = element.id!;
          _findUserAndDeleteWorkout(element.userPhoneNumber!, workoutId);
        }
      }
    }
  }

  void _sendNotification(String userPhone, String workoutId) {
    // _firebaseController.send("Log", {
    //   DateFormat('yyyy-MM-dd hh-mm-ss').format(DateTime.now()):
    //       extensions.administratorCancelledWorkout(userPhone, workoutId)
    // });
  }

  void _findUserAndDeleteWorkout(String userPhoneNumber, String workoutId) {
    String userId = "";
    _firebaseController.get(UserRole.user).then((users) {
      users.forEach((key, value) {
        if (value["Телефон"] == userPhoneNumber) {
          userId = key;
        }
      });
      _firebaseController
          .delete(
              "${UserRole.instructor}/${_currentInstructor!.id!}/Занятия/Занятие $workoutId")
          .then((value) {
        _firebaseController
            .delete("${UserRole.user}/$userId/Занятия/$workoutId")
            .then((value) {
          setState(() {});
        });
      });
    });
  }

  void _showWarningCancelDialog(String date, String time) {
    String formattedDate =
        "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "Запрос на отмену отправлен. \n $formattedDate и \n $time",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text(
                'ОК',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showWarningChangeTimeDialogForAdmin(Function onApprove) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            "Изменить время?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: const Text(
                'ДА',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                onApprove.call();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'НЕТ',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _getAllWorkoutsPerDay() {
    String dateString = DateFormat('ddMMyyyy').format(_selectedDate);
    List<Workout> workouts = [];
    for (var element in _currentInstructor!.workouts!) {
      if (element.date == dateString) {
        workouts.add(element);
      }
    }
    _workoutsPerDay = workouts;
  }

  bool _checkChangeTimePossibility(String time) {
    bool possibility = true;
    if (_workoutsPerDay.isNotEmpty) {
      for (var element in _workoutsPerDay) {
        if (_timesController.checkTimeInterval(
            time, element.from!, element.to!)) {
          possibility = false;
          break;
        }
      }
      return possibility;
    } else {
      return true;
    }
  }

  void _getOpenedTimesPerDay() {
    _openedTimesPerDay = [];
    _notAvailableTimesPerDay = [];
    _closedTimesPerDay = [];
    String dateString = DateFormat('ddMMyyyy').format(_selectedDate);
    Map<dynamic, dynamic>? timesMap = _currentInstructor!.schedule![dateString];
    if (timesMap != null) {
      timesMap.forEach((key, value) {
        if (value == 'открыто' && !_openedTimesPerDay.contains(key)) {
          _openedTimesPerDay.add(key);
        } else if (value == 'не открыто' &&
            !_notAvailableTimesPerDay.contains(key)) {
          _notAvailableTimesPerDay.add(key);
        } else if (value == 'недоступно' && !_closedTimesPerDay.contains(key)) {
          _closedTimesPerDay.add(key);
        }
      });
    }
  }

  void _getOpenedTimesPerMonth() {
    if (_currentInstructor!.schedule != null) {
      _fillMarkedDateMap(_getDatesWithOpenedRegistration(
          _currentInstructor!.schedule!,
          UserRole.instructor,
          FirebaseAuth.instance.currentUser!.uid));
    }
  }

  List<DateTime> _getDatesWithOpenedRegistration(
      Map<dynamic, dynamic> allDates, String userRole, String userId) {
    DateTime now = DateTime.now();
    List<DateTime> markedDates = [];
    allDates.forEach((key, value) {
      String date = key.toString();
      String formattedDate =
          "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
      DateTime dateTime = DateTime.parse(formattedDate);
      if (dateTime.isBeforeDate(now)) {
        _firebaseController.delete("$userRole/$userId/График работы/$date");
      } else {
        (value as Map<dynamic, dynamic>).forEach((key, value) {
          if (value == 'открыто' && !markedDates.contains(dateTime)) {
            markedDates.add(dateTime);
          }
        });
      }
    });
    return markedDates;
  }

  void _fillMarkedDateMap(List<DateTime> markedDates) {
    _markedDateMap.clear();
    for (var date in markedDates) {
      _markedDateMap.add(date, _createEvent(date));
    }
  }

  Event _createEvent(DateTime dateTime) {
    return Event(
        date: dateTime, dot: Container(), icon: _markedDateIcon(dateTime));
  }

  Widget _markedDateIcon(DateTime dateTime) {
    return Center(
      child: Text(
        dateTime.day.toString(),
        style: TextStyle(
            color:
                dateTime.isSameDate(_selectedDate) ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Color _getTimeButtonColor(String time) {
    return Colors.white;
  }

  Color _getTimeTextColor(String time) {
    if (_openedTimesPerDay.contains(time)) {
      return Colors.blue;
    } else if (_closedTimesPerDay.contains(time)) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Widget _changeStatusButtons() {
    return Column(
      children: [
        _changeStatusButton(TimeStatus.OPENED, "открыта предварительная запись",
            "assets/instructor_set_time/e5.png"),
        _changeStatusButton(TimeStatus.NOT_AVAILABLE,
            "запись недоступна(перерыв)", "assets/instructor_set_time/e4.png"),
        _changeStatusButton(
            TimeStatus.NOT_OPENED,
            "предварительная запись не открыта",
            "assets/instructor_set_time/e15.png"),
      ],
    );
  }

  Widget _changeStatusButton(String timeStatus, String text, String iconPath) {
    return Container(
      height: screenHeight * 0.033,
      margin: EdgeInsets.only(left: screenWidth * 0.2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeStatus = timeStatus;
          });
        },
        child: Row(
          children: [
            Container(
              height: 8,
              width: 8,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(iconPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _selectedTimeStatus == timeStatus ? 14 : 12),
            )
          ],
        ),
      ),
    );
  }
}
