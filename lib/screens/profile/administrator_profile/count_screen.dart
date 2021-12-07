import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/screens/extension.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/widgets/smeta_instructord.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data_keepers/instructors_keeper.dart';
import '../../../main.dart';
import '../../../model/workout.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';

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
    super.initState();
  }

  void _getInstructors() {
    instructorlist = _instructorsKeeper.instructorsList;
  }

  DateTime selectedDate = DateTime.now();
  TextEditingController onePeopleController = TextEditingController();
  TextEditingController twoPeopleController = TextEditingController();
  TextEditingController threePeopleController = TextEditingController();
  TextEditingController fourPeopleController = TextEditingController();

  List<Instructor> instructorlist = [];

  final EventList<Event> _markedDateMap = EventList<Event>(events: Map());
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: update,
          child: Container(
            height: screenHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white70),
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
                              selectedDate,
                              text: "C",
                            ),
                            DateWidget(
                              this,
                              selectedDate,
                              text: "До",
                            ),
                          ],
                        ),
                        _instructorListWidget(),
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

  Widget _instructorListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 50, right: 8, left: 8),
      child: Column(
        children: List.generate(instructorlist.length, (index) {
          return InstructorDataWidget(
            instructorlist[index],
            selectedDate: selectedDate,
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
              onTap: () {},
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
