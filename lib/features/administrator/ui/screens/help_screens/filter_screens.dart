import 'dart:developer';
import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/date_widget/date_widget.dart';
import 'package:academ_gora_release/core/data_keepers/filter_datakeeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/all_instructors/all_instructors_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class FilterScreen extends StatefulWidget {
  final bool fromArchive;
  final bool fromCurrent;
  const FilterScreen(
      {Key? key, this.fromArchive = false, this.fromCurrent = false})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final FilterKeeper _filterKeeper = FilterKeeper();
  bool isSkiesSelected = true;
  bool isSnowBoardSelected = true;
  bool isCompleteSelected = true;
  bool isCanceledSelected = true;
  List<Instructor> instructorlist = [];
  List<Instructor> filteredList = [];
  List<Instructor> removeList = [];
  DateTime firstDate = DateTime.now();
  DateTime secondDate = DateTime.now();
  List<CheckBoxState> instructorCheckBoxList = [];
  CheckBoxStateAll allInstructorsChecBox = CheckBoxStateAll(tittle: "Все");

  @override
  void initState() {
    getdateFromdateKeeper();
    super.initState();
  }

  void getdateFromdateKeeper() {
    setState(
      () {
        log("_filterKeeper.instructorCheckBoxList ${_filterKeeper.instructorCheckBoxList.length}");
        isSkiesSelected = _filterKeeper.isSkiesSelected;
        isSnowBoardSelected = _filterKeeper.isSnowBoardSelected;
        isCompleteSelected = _filterKeeper.isCompleteSelected;
        isCanceledSelected = _filterKeeper.isCompleteSelected;
        firstDate = _filterKeeper.firstDate;
        allInstructorsChecBox = _filterKeeper.allInstructorChecBoxState;
        secondDate = _filterKeeper.secondDate;
        instructorCheckBoxList =
            List.from(_filterKeeper.instructorCheckBoxList);
        filteredList = List.from(_filterKeeper.filteredInstructorList);
        instructorlist = List.from(_filterKeeper.instuctorList);
      },
    );
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
                  buildCalendar(),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [buildDowntButtons()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return !widget.fromCurrent
        ? Column(
            children: [
              _myRegistrationsTitle(text: "Выберите число"),
              buildDateButtons(),
            ],
          )
        : Container();
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
                    ? const EdgeInsets.only(bottom: 40)
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
              if (filteredList.contains(instructorCheckBox.instructor)) {
                filteredList.remove(
                  instructorCheckBox.instructor,
                );
              }
            } else {
              if (!filteredList.contains(instructorCheckBox.instructor)) {
                filteredList.add(instructorCheckBox.instructor);
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
      for (var element in instructorlist) {
        if (element.kindOfSport == KindsOfSport.SNOWBOARD) {
          removeList.add(element);
        }
      }
      for (var element in removeList) {
        if (filteredList.contains(element)) {
          filteredList.remove(element);
        }
      }
      allInstructorsChecBox.value = isSnowBoardSelected;
      removeList = [];
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

  void confirmFilters() {
    _filterKeeper.updateFilterL(
      fisSkiesSelected: isSkiesSelected,
      fisSnowBoardSelected: isSnowBoardSelected,
      fisCompleteSelected: isCanceledSelected,
      fisCanceledSelected: isCanceledSelected,
      ffilterList: filteredList,
      ffirstTime: firstDate,
      fsecondTime: secondDate,
      fallInctructorCheck: allInstructorsChecBox,
      finstructorCheckBoxList: instructorCheckBoxList,
    );
    Navigator.pop(context);
  }

  void resetFilter() {
    _filterKeeper.clearfilter();
    getdateFromdateKeeper();
    Navigator.pop(context);
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
            onTap: () async {
              resetFilter();
            },
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
              confirmFilters();
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
