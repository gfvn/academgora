import 'dart:developer';

import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/common/times_controller.dart';
import 'package:academ_gora_release/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/workout.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/widgets/smeta_instructord.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data_keepers/instructors_keeper.dart';
import '../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/count_data_widget.dart';

class CountScreen extends StatefulWidget {
  final DateTime choosedDateTime;
  const CountScreen({Key? key, required this.choosedDateTime})
      : super(key: key);

  @override
  State<CountScreen> createState() => CountScreenState();
}

class CountScreenState extends State<CountScreen> {
  @override
  void initState() {
    _getInstructors();
    _getAllPrices();
    firstDate = widget.choosedDateTime;
    secondDate = widget.choosedDateTime;
    super.initState();
  }

  void _getInstructors() {
    instructorlist = _instructorsKeeper.instructorsList;
  }

  void _getAllPrices() {
    priceList = _priceDataKeeper.priceListOfString;
    if (priceList.isNotEmpty) {
      onePeopleController.text = priceList[0];
      twoPeopleController.text = priceList[1];
      threePeopleController.text = priceList[2];
      fourPeopleController.text = priceList[3];
      onePrice = int.parse(priceList[0]);
      twoPrice = int.parse(priceList[1]);
      threePrice = int.parse(priceList[2]);
      fourPrice = int.parse(priceList[3]);
    }

    setState(() {});
  }

  void setPricec() async {
    List<String> priceList = [];
    final prefs = await SharedPreferences.getInstance();
    priceList.add(onePeopleController.text);
    priceList.add(twoPeopleController.text);
    priceList.add(threePeopleController.text);
    priceList.add(fourPeopleController.text);
    prefs.setStringList('price', priceList);
  }

  int sum = 0;
  int onePrice = 0;
  int twoPrice = 0;
  int threePrice = 0;
  int fourPrice = 0;

  TextEditingController onePeopleController = TextEditingController();
  TextEditingController twoPeopleController = TextEditingController();
  TextEditingController threePeopleController = TextEditingController();
  TextEditingController fourPeopleController = TextEditingController();
  List<Instructor> instructorlist = [];
  List<String> priceList = [];
  List<DateTime> listOfDates = [];

  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  DateTime firstDate = DateTime.now();
  DateTime secondDate = DateTime.now();

  final PriceKeeper _priceDataKeeper = PriceKeeper();

  Future<void> update() async {
    await _firebaseController.get('Инструкторы').then(
      (value) {
        _instructorsKeeper.updateInstructors(value);
      },
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(
      () {},
    );
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

  void countAllInstructorPrice() {
    int instructorSum = 0;
    for (Instructor instructor in instructorlist) {
      print("instructorSum $instructorSum");
      instructorSum = instructorSum +
          countWorkoutsPriceOneInstructor(
              _sortWorkoutsBySelectedDate(instructor.workouts!));
    }
    setState(() {
      sum = instructorSum;
    });
  }

  List<Workout> _sortWorkoutsBySelectedDate(List<Workout> list) {
    List<Workout> sortedWorkouts = [];
    if (list.isNotEmpty) {
      for (var workout in list) {
        String workoutDateString = workout.date!;
        String now = DateFormat('ddMMyyyy').format(firstDate);
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

  int countWorkoutsPriceOneInstructor(List<Workout> workouts) {
    int summAllWorkout = 0;
    for (Workout workout in workouts) {
      int price = getWorkoutPrice(workout.peopleCount);
      summAllWorkout = summAllWorkout + workout.workoutDuration! * price;
    }
    return summAllWorkout;
  }

  Widget buildSummAllInstructor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Text(
            'Итого: $sum',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    countAllInstructorPrice();
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: update,
          child: Container(
            height: screenHeight,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white70),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 50, right: 20, left: 20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: ListView(
                      children: [
                        _myRegistrationsTitle(text: 'Подсчёт'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DateWidget(
                              this,
                              firstDate,
                              text: "C",
                              isFirstdate: true,
                            ),
                            DateWidget(
                              this,
                              secondDate,
                              text: "До",
                              isFirstdate: false,
                            ),
                          ],
                        ),
                        isOneDay() ? oneDayIsntructor() : manyDaysInstructor()
                      ],
                    ),
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

  bool isOneDay() {
    return firstDate == secondDate;
  }

  Widget oneDayIsntructor() {
    return Column(
      children: [_instructorListWidget(), buildSummAllInstructor()],
    );
  }

  void updateListOfDates() {
    setState(() {
      listOfDates = getDaysInBetween(firstDate, secondDate);
    });
  }

  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  Widget manyDaysInstructor() {
    updateListOfDates();
    return Column(
        children: List.generate(listOfDates.length, (index) {
      return Text(listOfDates[index].toString());
    }));
  }

  Widget _instructorListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50, right: 8, left: 8),
      child: Column(
        children: List.generate(instructorlist.length, (index) {
          return InstructorDataWidget(
            instructorlist[index],
            selectedDate: firstDate,
            isNeedCount: true,
          );
        }),
      ),
    );
  }

  Widget buildInstructionText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text("Стоимость занятия при n количество человек"),
    );
  }

  Widget buildInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildOneInputs(text: "1:", controller: onePeopleController),
        buildOneInputs(text: "2:", controller: twoPeopleController),
        buildOneInputs(text: "3:", controller: threePeopleController),
        buildOneInputs(text: "4:", controller: fourPeopleController),
      ],
    );
  }

  Widget buildOneInputs(
      {required String text, required TextEditingController controller}) {
    return Row(
      children: [
        _titleWidget(text),
        _textFieldWidget(
            width: screenWidth * 0.14,
            textInputType: TextInputType.number,
            controller: controller)
      ],
    );
  }

  Widget _titleWidget(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }

  Widget _textFieldWidget(
      {required double width,
      required TextInputType textInputType,
      required TextEditingController controller}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3, left: 10),
      height: 30,
      width: width,
      child: TextField(
        onSubmitted: (s) {
          // {widget.registrationParametersScreenState.setState(() {})};
        },
        keyboardType: textInputType,
        controller: controller,
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
    );
  }

  Widget buildButtons() {
    return Column(
      children: [
        buildInstructionText(),
        buildInputs(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            button(
              text: "Назад",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            button(
              text: "Сохранить",
              onTap: () {
                setPricec();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _myRegistrationsTitle({required String text}) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(right: 20, top: 16, bottom: 16),
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
          color: Colors.blue,
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
}
