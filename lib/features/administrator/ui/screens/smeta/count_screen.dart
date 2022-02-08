import 'dart:developer';

import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/common/times_controller.dart';
import 'package:academ_gora_release/core/components/date_widget/date_widget.dart';
import 'package:academ_gora_release/core/data_keepers/filter_datakeeper.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/help_screens/filter_screens.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/widgets/smeta_instructord.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:academ_gora_release/core/style/color.dart';
import '../../../../../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expandable/expandable.dart';

class CountScreen extends StatefulWidget {
  final DateTime choosedDateTime;
  const CountScreen({Key? key, required this.choosedDateTime})
      : super(key: key);

  @override
  State<CountScreen> createState() => CountScreenState();
}

class CountScreenState extends State<CountScreen> {
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final PriceKeeper _priceDataKeeper = PriceKeeper();
  final ExpandableController _expandableController = ExpandableController();
  final FilterKeeper _filterKeeper = FilterKeeper();

  int sumOneDay = 0;
  int sumAllDay = 0;
  int onePrice = 0;
  int twoPrice = 0;
  int threePrice = 0;
  int fourPrice = 0;
  TextEditingController onePeopleController = TextEditingController();
  TextEditingController twoPeopleController = TextEditingController();
  TextEditingController threePeopleController = TextEditingController();
  TextEditingController fourPeopleController = TextEditingController();
  List<Instructor> instructorlist = [];
  List<Instructor> filteredInstructorList = [];
  List<String> priceList = [];
  List<DateTime> listOfDates = [];
  DateTime firstDate = DateTime.now();
  DateTime secondDate = DateTime.now();
  bool isUpdate = true;
  bool showAllInstructors = true;

  @override
  void initState() {
    _getInstructors();
    _getAllPrices();
    firstDate = widget.choosedDateTime;
    secondDate = widget.choosedDateTime;
    super.initState();
  }

  @override
  void dispose() {
    _filterKeeper.clearfilter();
    super.dispose();
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

    setState(
      () {},
    );
  }

  void setPricec() async {
    List<String> priceList = [];
    final prefs = await SharedPreferences.getInstance();
    priceList.add(onePeopleController.text);
    priceList.add(twoPeopleController.text);
    priceList.add(threePeopleController.text);
    priceList.add(fourPeopleController.text);
    prefs.setStringList('price', priceList);

    setState(
      () {
        _priceDataKeeper.updateWorkouts(priceList);
        _getAllPrices();
      },
    );
  }

  Future<void> update() async {
    await _firebaseController.get('Инструкторы').then(
      (value) {
        _instructorsKeeper.updateInstructors(value);
      },
    );
    await Future.delayed(const Duration(milliseconds: 2000));
    setState(
      () {
        isUpdate = true;
        _getInstructors();
        _getAllPrices();
      },
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

  int countAllInstructorPrice(DateTime selectedTime) {
    int instructorSum = 0;
    for (Instructor instructor in instructorlist) {
      instructorSum = instructorSum +
          countWorkoutsPriceOneInstructor(
            _sortWorkoutsBySelectedDate(instructor.workouts!, selectedTime),
          );
    }
    return instructorSum;
  }

  List<Workout> _sortWorkoutsBySelectedDate(
      List<Workout> list, DateTime selectedDate) {
    List<Workout> sortedWorkouts = [];
    if (list.isNotEmpty) {
      for (var workout in list) {
        String workoutDateString = workout.date!;
        String now = DateFormat('ddMMyyyy').format(selectedDate);
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

  Widget buildSummAllInstructor(DateTime time) {
    int sumOfOneDay = countAllInstructorPrice(time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 32, left: 32),
          child: Text(
            'Итого дня: $sumOfOneDay',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    updateListOfDates();
    _getInstructors();
    // _getAllPrices();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Подсчёт",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const FilterScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.filter_alt_rounded),
            ),
          )
        ],
      ),
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
                    padding: const EdgeInsets.only(bottom: 150),
                    child: ListView(
                      children: [
                        Stack(
                          children: [
                            _myRegistrationsTitle(text: "Инструкторы"),
                            Positioned(
                              right: 10,
                              bottom: 5,
                              child: InkWell(
                                onTap: () => setState(
                                  () {
                                    showAllInstructors = !showAllInstructors;
                                    _expandableController.toggle();
                                  },
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  height: 40,
                                  width: 40,
                                  child: showAllInstructors
                                      ? const Icon(
                                          Icons.arrow_drop_down,
                                          size: 32,
                                        )
                                      : const Icon(
                                          Icons.arrow_drop_up,
                                          size: 32,
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        isOneDay()
                            ? oneDayIsntructor(firstDate)
                            : manyDaysInstructor()
                      ],
                    ),
                  ),
                  Positioned(bottom: 50, child: buildButtons()),
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

  Widget oneDayIsntructor(DateTime time) {
    countAllInstructorPrice(time);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _instructorListWidget(time),
        buildSummAllInstructor(time),
      ],
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

  int countAllDaysPrice() {
    int sum = 0;
    for (DateTime time in listOfDates) {
      sum = sum + countAllInstructorPrice(time);
    }
    return sum;
  }

  Widget manyDaysInstructor() {
    updateListOfDates();
    return Column(
      children: [
        Column(
          children: List.generate(
            listOfDates.length,
            (index) {
              return buildManyInstructorItem(
                listOfDates[index],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: buildSumAlldays(),
        ),
      ],
    );
  }

  Widget buildManyInstructorItem(DateTime time) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: _titleWidget(
            _getSelectedDate(time),
          ),
        ),
        oneDayIsntructor(time),
      ],
    );
  }

  Widget buildSumAlldays() {
    int sum = countAllDaysPrice();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [_sumWidget(sum.toString())],
    );
  }

  String _getSelectedDate(DateTime time) {
    String month = months[time.month - 1];
    String weekday = weekdays[time.weekday - 1];
    return "${time.day} $month ($weekday)";
  }

  Widget _instructorListWidget(DateTime selectedDate) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, right: 8, left: 8),
      child: Column(
        children: List.generate(instructorlist.length, (index) {
          return InstructorDataWidget(
            instructorlist[index],
            selectedDate: selectedDate,
            isNeedCount: true,
            isUpdate: isUpdate,
            expandedController: _expandableController,
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
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _sumWidget(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      child: Text(
        "Итого: $text",
        style: const TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
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
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
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
        ),
      ),
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
}
