import 'dart:developer';

import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/date_widget/date_widget.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/all_instructors/all_instructors_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class FilterScreen extends StatefulWidget {
  final bool fromArchive;
  const FilterScreen({Key? key, this.fromArchive = false}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool isSkiesSelected = true;
  bool isSnowBoardSelected = true;
  bool isCompleteSelected = true;
  bool isCanceledSelected = true;
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  List<Instructor> instructorlist = [];
  List<Instructor> filteredList = [];
  List<Instructor> removeList = [];
  DateTime firstDate = DateTime.now();
  DateTime secondDate = DateTime.now();
  List<CheckBoxState> instructorCheckBoxList = [];
  final allInstructorsChecBox = CheckBoxStateAll(tittle: "Все");

  @override
  void initState() {
    _getInstructors();
    createChecBoxList();
    super.initState();
  }

  void createChecBoxList() {
    instructorCheckBoxList = List.generate(
      filteredList.length,
      (index) {
        return CheckBoxState(instructor: filteredList[index]);
      },
    );
  }

  void _getInstructors() {
    filteredList = List.from(_instructorsKeeper.instructorsList);
    instructorlist = List.from(_instructorsKeeper.instructorsList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Фильтр",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _myRegistrationsTitle(text: "Выберите число"),
                  buildDateButtons(),
                  _myRegistrationsTitle(text: "Вид спорта"),
                  buildSportButtons(),
                  buildrelevanceButtons(),
                  _myRegistrationsTitle(text: "Инструкторы"),
                  buildGroupCheckBox(allInstructorsChecBox),
                  Divider(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  buildListOfInstructors()
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [buildDowntButtons()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListOfInstructors() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: List.generate(
            instructorCheckBoxList.length,
            (index) {
              return Padding(
                padding: index == instructorCheckBoxList.length - 1
                    ? const EdgeInsets.only(bottom: 30)
                    : const EdgeInsets.only(bottom: 1),
                child: buildListViewItem(
                  instructorCheckBoxList[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildListViewItem(CheckBoxState instructorCheckBox) {
    return CheckboxListTile(
      title: Text(
        instructorCheckBox.instructor.name!,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(instructorCheckBox.instructor.phone ?? ""),
          Text(instructorCheckBox.instructor.kindOfSport.toString()),
        ],
      ),
      value: instructorCheckBox.value,
      onChanged: (value) {
        setState(
          () {
            instructorCheckBox.value = value!;
            allInstructorsChecBox.value = instructorCheckBoxList.every(
              (element) {
                return element.value;
              },
            );
            if (instructorCheckBox.value == false) {
              if (instructorCheckBox.instructor.kindOfSport ==
                  KindsOfSport.SKIES) {
                isSkiesSelected = false;
              } else {
                isSnowBoardSelected = false;
              }
            }
          },
        );
      },
      activeColor: kMainColor,
    );
  }

  Widget buildGroupCheckBox(CheckBoxStateAll checkBoxAll) {
    return CheckboxListTile(
      title: Text(checkBoxAll.tittle),
      onChanged: toggleGroupCheckBox,
      activeColor: kMainColor,
      value: checkBoxAll.value,
    );
  }

  void toggleGroupCheckBox(bool? value) {
    if (value == null) return;
    setState(
      () {
        allInstructorsChecBox.value = value;
        isSkiesSelected = allInstructorsChecBox.value!;
        isSnowBoardSelected = allInstructorsChecBox.value!;
        for (var element in instructorCheckBoxList) {
          element.value = value;
        }
        if (value == false) {
          filteredList = [];
        } else {
          filteredList = instructorlist;
        }
      },
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

  Widget buildSportButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          filterSelectionButton(
            tittle: "Сноуборд",
            selections: isSkiesSelected,
            onTap: () {
              setState(() {
                filterSkiiButtonPress();
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
          filterSelectionButton(
            tittle: "Горные лыжи",
            selections: isSnowBoardSelected,
            onTap: () {
              setState(() {
                filterSnowBoardPress();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildrelevanceButtons() {
    return widget.fromArchive
        ? Column(
            children: [
              _myRegistrationsTitle(text: "Актуальность"),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    filterSelectionButton(
                      tittle: "Проведено",
                      selections: isCompleteSelected,
                      onTap: () {
                        setState(() {
                          filterCompletePress();
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    filterSelectionButton(
                      tittle: "Отменено",
                      selections: isCanceledSelected,
                      onTap: () {
                        setState(() {
                          filterCanceledSelect();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container();
  }

  void filterCompletePress() {
    isCompleteSelected = !isCompleteSelected;
  }

  void filterCanceledSelect() {
    isCanceledSelected = !isCanceledSelected;
  }

  void filterSkiiButtonPress() {
    isSkiesSelected = !isSkiesSelected;
    if (isSkiesSelected == false) {
      for (var element in instructorlist) {
        if (element.kindOfSport == KindsOfSport.SKIES) {
          removeList.add(element);
        }
      }
      for (var element in removeList) {
        if (filteredList.contains(element)) {
          filteredList.remove(element);
        }
      }
      allInstructorsChecBox.value = isSkiesSelected;
      removeList = [];
    } else {
      if (isSnowBoardSelected == true) {
        allInstructorsChecBox.value = true;
      }
      for (var element in instructorlist) {
        if (element.kindOfSport == KindsOfSport.SKIES) {
          if (!filteredList.contains(element)) {
            filteredList.add(element);
          }
        }
      }
    }
    for (var element in instructorCheckBoxList) {
      if (element.instructor.kindOfSport == KindsOfSport.SKIES) {
        element.value = isSkiesSelected;
      }
    }
  }

  void filterSnowBoardPress() {
    isSnowBoardSelected = !isSnowBoardSelected;
    if (isSnowBoardSelected == false) {
      for (Instructor element in instructorlist) {
        if (element.kindOfSport == KindsOfSport.SNOWBOARD) {
          filteredList.remove(element);
        }
      }
      allInstructorsChecBox.value = isSnowBoardSelected;
    } else {
      if (isSkiesSelected == true) {
        allInstructorsChecBox.value = true;
      }
      for (var element in instructorlist) {
        if (element.kindOfSport == KindsOfSport.SNOWBOARD) {
          if (!filteredList.contains(element)) {
            filteredList.add(element);
          }
        }
      }
    }
    for (var element in instructorCheckBoxList) {
      if (element.instructor.kindOfSport == KindsOfSport.SNOWBOARD) {
        element.value = isSnowBoardSelected;
      }
    }
  }

  Widget filterSelectionButton(
      {required String tittle,
      required bool selections,
      required Function onTap}) {
    return AcademButton(
      onTap: onTap,
      tittle: tittle,
      width: screenWidth * 0.4,
      fontSize: 14,
      borderColor: kMainColor,
      colorText: selections ? kWhite : kMainColor,
      colorButton: selections ? kMainColor : Colors.transparent,
    );
  }

  Widget snowBoardButton() {
    return AcademButton(
      onTap: () async {
        setState(
          () {
            filterSnowBoardPress();
          },
        );
      },
      tittle: "Сноуборд",
      width: screenWidth * 0.4,
      fontSize: 14,
      borderColor: kMainColor,
      colorText: isSnowBoardSelected ? kWhite : kMainColor,
      colorButton: isSnowBoardSelected ? kMainColor : Colors.transparent,
    );
  }

  Widget buildDateButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
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
        ],
      ),
    );
  }

  Widget buildDowntButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: screenWidth,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AcademButton(
            onTap: () async {},
            tittle: "Отменить",
            width: screenWidth * 0.4,
            fontSize: 14,
            borderColor: kMainColor,
            colorText: kMainColor,
            colorButton: Colors.transparent,
          ),
          const SizedBox(
            width: 10,
          ),
          AcademButton(
            onTap: () {
              log("instructorbnblist ${instructorlist.length}");
              log("llllllll  ${_instructorsKeeper.instructorsList.length}");
              log("filter  ${filteredList.length}");
            },
            tittle: "Применить",
            width: screenWidth * 0.4,
            fontSize: 14,
          )
        ],
      ),
    );
  }
}

class CheckBoxState {
  final Instructor instructor;
  bool value;
  CheckBoxState({
    required this.instructor,
    this.value = true,
  });
}

class CheckBoxStateAll {
  final String tittle;
  bool? value;
  CheckBoxStateAll({
    required this.tittle,
    this.value = true,
  });
}
