import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/set_workout_time_screen/presentation/set_workout_time_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/workout_data_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import 'package:intl/intl.dart';

import '../../../main.dart';
import '../../extension.dart';
import '../../main_screen.dart';
import 'instructor_profile_screen.dart';

class InstructorWorkoutsScreen extends StatefulWidget {
  final String? instructorPhoneNumber;

  const InstructorWorkoutsScreen({Key? key, this.instructorPhoneNumber})
      : super(key: key);

  @override
  _InstructorWorkoutsScreenState createState() =>
      _InstructorWorkoutsScreenState();
}

class _InstructorWorkoutsScreenState extends State<InstructorWorkoutsScreen> {
  DateTime _selectedDate = DateTime.now();

  List<Workout> _workoutsPerDay = [];
  List<Workout> _allWorkouts = [];

  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  final EventList<Event> _markedDateMap = EventList<Event>(events: Map());
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  @override
  Widget build(BuildContext context) {
    _getAllWorkouts();
    _fillMarkedDateMap();
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: screenDecoration("assets/instructor_profile/bg.png"),
      child: Column(
        children: [
          _titleRow(),
          _changeRegistrationTimeButton(),
          _calendar(),
          _dateSliderWidget(),
          _workoutsListWidget(),
          _redactProfileButton(),
          _backToMainButton()
        ],
      ),
    ));
  }

  Widget _titleRow() {
    return Container(
        margin: const EdgeInsets.only(top: 28, right: 28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [_myRegistrationsTitle(), _logoutButton()],
        ));
  }

  Widget _myRegistrationsTitle() {
    return Container(
        margin: const EdgeInsets.only(right: 20),
        child: const Text(
          "Мои записи",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ));
  }

  Widget _logoutButton() {
    return GestureDetector(
        onTap: () {
          showLogoutDialog(context, _logout);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "ВЫЙТИ",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Container(
                margin: const EdgeInsets.only(left: 5),
                height: 20,
                width: 20,
                child: const Icon(Icons.logout))
          ],
        ));
  }

  Widget _changeRegistrationTimeButton() {
    return Container(
      width: screenWidth * 0.7,
      height: screenHeight * 0.065,
      margin: const EdgeInsets.only(top: 12),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: _openSetWorkoutTimeScreen,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ОТКРЫТЬ/ИЗМЕНИТЬ\n ДОСТУПНОЕ ВРЕМЯ ЗАПИСИ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget _dateSliderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _decreaseDate,
          child: SizedBox(
            height: screenWidth * 0.07,
            width: screenWidth * 0.07,
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
            height: screenWidth * 0.07,
            width: screenWidth * 0.07,
            child: Image.asset("assets/instructors_list/e_7.png"),
          ),
        ),
      ],
    );
  }

  String _getSelectedDate() {
    String month = months[_selectedDate.month - 1];
    String weekday = weekdays[_selectedDate.weekday - 1];
    return "${_selectedDate.day} $month ($weekday)";
  }

  void _increaseDate() {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: 1));
    });
    _getAllWorkouts();
  }

  void _decreaseDate() {
    if (_selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day) {
      return;
    } else {
      setState(() {
        _selectedDate = _selectedDate.subtract(Duration(days: 1));
      });
      _getAllWorkouts();
    }
  }

  Widget _redactProfileButton() {
    return Container(
      width: screenWidth * 0.65,
      height: screenHeight * 0.058,
      margin: const EdgeInsets.only(top: 5),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: _openRedactProfileScreen,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "РЕДАКТИРОВАТЬ ПРОФИЛЬ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget _backToMainButton() {
    return Container(
      width: screenWidth * 0.5,
      height: screenHeight * 0.056,
      margin: const EdgeInsets.only(top: 7),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: _openMainScreen,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "НА ГЛАВНУЮ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  Widget _calendar() {
    return CalendarCarousel<Event>(
      selectedDayButtonColor: Colors.blue,
      headerMargin: const EdgeInsets.all(0),
      headerTextStyle:
          TextStyle(fontSize: screenHeight * 0.023, color: Colors.blue),
      weekdayTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      locale: "ru",
      width: screenWidth * 0.69,
      height: screenHeight * 0.43,
      todayBorderColor: Colors.transparent,
      todayButtonColor: Colors.transparent,
      todayTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      onDayPressed: (DateTime date, List<Event> events) {
        if (date.isAfter(DateTime.now()) || date.isSameDate(DateTime.now())) {
          setState(() => _selectedDate = date);
          _getAllWorkouts();
        }
      },
      weekendTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      daysTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
      selectedDateTime: _selectedDate,
      targetDateTime: _selectedDate,
      selectedDayTextStyle: const TextStyle(color: Colors.white),
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconBuilder: (e) => e.icon,
    );
  }

  void _fillMarkedDateMap() {
    _markedDateMap.clear();
    for (var element in _allWorkouts) {
      String date = element.date!;
      String formattedDate =
          "${date.substring(4, 8)}-${date.substring(2, 4)}-${date.substring(0, 2)}";
      DateTime dateTime = DateTime.parse(formattedDate);
      if (!_markedDateMap.events.containsKey(dateTime)) {
        _markedDateMap.add(dateTime, _createEvent(dateTime));
      }
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
                _compareDateWithSelected(dateTime) ? Colors.white : Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  bool _compareDateWithSelected(DateTime dateTime) {
    return dateTime.year == _selectedDate.year &&
        dateTime.month == _selectedDate.month &&
        dateTime.day == _selectedDate.day;
  }

  Widget _workoutsListWidget() {
    return SizedBox(
        height: screenHeight * 0.22,
        width: screenWidth * 0.6,
        child: ListView.builder(
          itemCount: _workoutsPerDay.length,
          itemBuilder: (context, index) {
            return WorkoutDataWidget(_workoutsPerDay[index]);
          },
        ));
  }

  void _getAllWorkouts() async {
    List<Workout>? workouts = [];
    if (widget.instructorPhoneNumber != null) {
      workouts = _instructorsKeeper
          .findInstructorByPhoneNumber(widget.instructorPhoneNumber!)!
          .workouts!;
    } else {
      workouts = _instructorsKeeper
          .findInstructorByPhoneNumber(
              FirebaseAuth.instance.currentUser!.phoneNumber!)!
          .workouts;
    }
    List<Workout> workoutsList = [];
    if (workouts != null) {
      for (var workout in workouts) {
        if (_workoutAfterOrSameOfNow(workout.date!)) {
          workoutsList.add(workout);
        } else {
          _deleteWorkout(workout.id!);
        }
      }
    }
    setState(() {
      _allWorkouts = workoutsList;
      _workoutsPerDay = _sortWorkoutsBySelectedDate(workoutsList);
    });
  }

  bool _workoutAfterOrSameOfNow(String workoutDate) {
    String formattedDate =
        "${workoutDate.substring(4, 8)}-${workoutDate.substring(2, 4)}-${workoutDate.substring(0, 2)}";
    DateTime workoutDateTime = DateTime.parse(formattedDate);
    DateTime now = DateTime.now();
    if (now.isBeforeDate(workoutDateTime) || now.isSameDate(workoutDateTime)) {
      return true;
    } else {
      return false;
    }
  }

  void _deleteWorkout(String workoutId) {
    if (widget.instructorPhoneNumber == null) {
      _firebaseController.delete(
          "${UserRole.instructor}/${FirebaseAuth.instance.currentUser!.uid}/Занятия/$workoutId");
    } else {
      Instructor currentInstructor = InstructorsKeeper()
          .findInstructorByPhoneNumber(widget.instructorPhoneNumber!)!;
      _firebaseController.delete(
          "${UserRole.instructor}/${currentInstructor.id}/Занятия/$workoutId");
    }
  }

  List<Workout> _sortWorkoutsBySelectedDate(List<Workout> list) {
    List<Workout> sortedWorkouts = [];
    if (list.isNotEmpty) {
      for (var workout in list) {
        String workoutDateString = workout.date!;
        String now = DateFormat('ddMMyyyy').format(_selectedDate);
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

  void _logout() async {
    FlutterAuthUi.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const AuthScreen()),
        (route) => false);
  }

  void _openRedactProfileScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => InstructorProfileScreen(
            instructorPhoneNumber: widget.instructorPhoneNumber)));
  }

  void _openSetWorkoutTimeScreen() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            SetWorkoutTimeScreen(phoneNumber: widget.instructorPhoneNumber!)));
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false);
  }
}
