import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/smeta/count_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/widgets/smeta_instructord.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../../../../main.dart';
import '../../../../instructor/domain/enteties/instructor.dart';
import '../../../../../core/consants/extension.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

class SmetaScreen extends StatefulWidget {
  const SmetaScreen({Key? key}) : super(key: key);

  @override
  _SmetaScreenState createState() => _SmetaScreenState();
}

class _SmetaScreenState extends State<SmetaScreen> {
  DateTime _selectedDate = DateTime.now();
  final List<Workout> _allWorkouts = [];
  List<Instructor> instructorlist = [];
  bool isUpdate = true;

  final EventList<Event> _markedDateMap = EventList<Event>(events: {});
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();

  @override
  void initState() {
    _getInstructors();
    super.initState();
  }

  void _getInstructors() {
    instructorlist = _instructorsKeeper.instructorsList;
  }

  void _getAllWorkouts() async {
    setState(() {});
  }

  void _decreaseDate() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    _getAllWorkouts();
  }

  String _getSelectedDate() {
    String month = months[_selectedDate.month - 1];
    String weekday = weekdays[_selectedDate.weekday - 1];
    return "${_selectedDate.day} $month ($weekday)";
  }

  void _increaseDate() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    _getAllWorkouts();
  }

  Future<void> update() async {
    await _firebaseController.get('Инструкторы').then(
      (value) async {
        await Future.delayed(const Duration(milliseconds: 3000));
        _instructorsKeeper.updateInstructors(value);
      },
    );
    setState(
      () {
        isUpdate = true;
        _getInstructors();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _getAllWorkouts();
    _fillMarkedDateMap();
    return Scaffold(
         appBar: AppBar(
        title: const Text(
          "Смета",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: update,
          child: Container(
            height: screenHeight-50,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white70),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 50, right: 20, left: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListView(
                    children: [
                      _myRegistrationsTitle(text: "Смета"),
                      _calendar(),
                      _dateSliderWidget(),
                      _myRegistrationsTitle(text: "Инструкторы"),
                      _instructorListWidget(),
                    ],
                  ),
                  Positioned(bottom: 5, child: buildButtons()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _instructorListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50, right: 8, left: 8),
      child: Column(
        children: List.generate(instructorlist.length, (index) {
          return InstructorDataWidget(
            instructorlist[index],
            isNeedCount: false,
            isUpdate: isUpdate,
            selectedDate: _selectedDate,
          );
        }),
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

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button(
          text: "Назад",
          onTap: () {
            Navigator.pop(context);
          },
        ),
        button(
          text: "Подсчет",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (c) => CountScreen(
                  choosedDateTime: _selectedDate,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _myRegistrationsTitle({required String text}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 16),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget button({required Function onTap, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.06,
        margin: const EdgeInsets.only(top: 16),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: kMainColor,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Event _createEvent(DateTime dateTime) {
    return Event(
        date: dateTime, dot: Container(), icon: _markedDateIcon(dateTime));
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

  Widget _markedDateIcon(DateTime dateTime) {
    return Center(
      child: Text(
        dateTime.day.toString(),
        style: TextStyle(
            color:
                _compareDateWithSelected(dateTime) ? Colors.white : kMainColor,
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

  Widget _calendar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 16, left: 16),
        child: CalendarCarousel<Event>(
          selectedDayButtonColor: kMainColor,
          headerMargin: const EdgeInsets.all(0),
          headerTextStyle:
              TextStyle(fontSize: screenHeight * 0.023, color: kMainColor),
          weekdayTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
          locale: "ru",
          width: screenWidth * 0.69,
          height: 300,
          todayBorderColor: Colors.transparent,
          todayButtonColor: Colors.transparent,
          todayTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
          onDayPressed: (DateTime date, List<Event> events) {
            setState(() => _selectedDate = date);
            _getAllWorkouts();
          },
          weekendTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
          daysTextStyle: const TextStyle(color: Colors.black, fontSize: 14),
          selectedDateTime: _selectedDate,
          targetDateTime: _selectedDate,
          selectedDayTextStyle: const TextStyle(color: Colors.white),
          markedDatesMap: _markedDateMap,
          markedDateShowIcon: true,
          markedDateIconBuilder: (e) => e.icon,
        ),
      ),
    );
  }
}
