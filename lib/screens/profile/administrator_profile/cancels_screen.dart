import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/data_keepers/cancel_keeper.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/cancel.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/classes_screen.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../../core/consants/extension.dart';
import '../instructor_profile/set_workout_time_screen/presentation/set_workout_time_screen.dart';

class CancelsScreen extends StatefulWidget {
  const CancelsScreen({Key? key}) : super(key: key);

  @override
  _CancelsScreenState createState() => _CancelsScreenState();
}

final CancelKeeper _cancelKeeper = CancelKeeper();

class _CancelsScreenState extends State<CancelsScreen> {
  List<CancelModel> cancelsList = [];
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  @override
  void initState() {
    _getCancels();
    super.initState();
  }

  void _getCancels() {
    cancelsList = _cancelKeeper.cancelModels;
  }

  Future<void> update() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await _firebaseController.get("Отмена").then(
      (value) {
        _cancelKeeper.updateInstructors(value);
        setState(() {
          cancelsList = _cancelKeeper.cancelModels;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Отменить занятия",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F1EE),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: RefreshIndicator(
              onRefresh: update,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: cancelsList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey<String>(
                        DateTime.now().millisecondsSinceEpoch.toString()),
                    background: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Удалить',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    secondaryBackground: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Удалить',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                    onDismissed: (DismissDirection direction) {
                      showDeleteNotifications(context,
                          confirmFunction: () async {
                        _firebaseController
                            .delete("Отмена/${cancelsList[index].workoutId}");
                        Navigator.pop(context);
                        await update();
                      }, cancelFunction: () async {
                        Navigator.pop(context);
                        await update();
                      });
                    },
                    child: cancelListItem(cancelsList[index]),
                  );
                },
              ),
            ),
          ),
          Positioned(bottom: 30, right: 20, left: 20, child: cancelButton()),
        ],
      ),
    );
  }

  Widget cancelButton() {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: kMainColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => const ClassesScreen()),
                (route) => false);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Назад",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cancelListItem(CancelModel cancelModel) {
    String formattedDate =
        "${cancelModel.date!.substring(4, 8)}-${cancelModel.date!.substring(2, 4)}-${cancelModel.date!.substring(0, 2)}";
    return InkWell(
      onTap: () {
        DateTime selected = DateTime(
            int.parse(cancelModel.date!.substring(4, 8)),
            int.parse(cancelModel.date!.substring(3, 4)),
            int.parse(cancelModel.date!.substring(0, 2)));
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => SetWorkoutTimeScreen(
              phoneNumber: cancelModel.instructorPhoneNumber,
              selectedDateFrom: selected,
              time: cancelModel.time,
              status: cancelModel.status,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          width: screenWidth,
          height: 130,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // ignore: prefer_const_literals_to_create_immutables
            boxShadow: [
              const BoxShadow(
                color: Colors.black,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Инструктор: "),
                    Text("${cancelModel.instructorName}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Телефон: "),
                    Text("${cancelModel.instructorPhoneNumber}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Вид занятия: "),
                    Text("${cancelModel.workoutSportType}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Дата: $formattedDate"),
                    Text("Время: ${cancelModel.time}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cтатус: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "${cancelModel.status}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
