import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/core/functions/functions.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/screens/instructor_profile/instructor_profile_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/instructor_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';

class AllInstructorsScreen extends StatefulWidget {
  const AllInstructorsScreen({Key? key}) : super(key: key);

  @override
  _AllInstructorsScreenState createState() => _AllInstructorsScreenState();
}

class _AllInstructorsScreenState extends State<AllInstructorsScreen> {
  String _selectedKindOfSport = "ГОРНЫЕ ЛЫЖИ";

  List<Instructor> _snowboardInstructors = [];
  List<Instructor> _skiesInstructors = [];

  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  @override
  void initState() {
    super.initState();
    _getInstructors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Инструкторы",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _instructorsList(),
          ],
        ),
      ),
    );
  }

  void _checkoutKindOfSport(String value) {
    setState(() {
      _selectedKindOfSport = value;
    });
  }

  Widget _instructorsList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _kindOfSportButton("ГОРНЫЕ ЛЫЖИ"),
            const SizedBox(
              width: 8,
            ),
            _kindOfSportButton("СНОУБОРД"),
          ],
        ),
        _instructorsListWidget(),
        AcademButton(
          tittle: 'НА ГЛАВНУЮ',
          onTap: () {
            FunctionsConsts.openMainScreen(context);
          },
          width: screenWidth * 0.9,
          fontSize: 18,
        ),
      ],
    );
  }

  Widget _kindOfSportButton(String name) {
    return GestureDetector(
      onTap: () {
        if (_selectedKindOfSport != name) {
          _checkoutKindOfSport(_selectedKindOfSport == "ГОРНЫЕ ЛЫЖИ"
              ? "СНОУБОРД"
              : "ГОРНЫЕ ЛЫЖИ");
        }
      },
      child: Container(
        padding: const EdgeInsets.only(right: 3, left: 3),
        width:
            _checkKindOfSport(name) ? screenWidth * 0.45 : screenWidth * 0.45,
        height: 50,
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(7)),
            color: _checkKindOfSport(name) ? kMainColor : Colors.white),
        child: Text(
          name,
          style: TextStyle(
            color: _checkKindOfSport(name) ? Colors.white : kMainColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  bool _checkKindOfSport(String name) {
    return (name == "ГОРНЫЕ ЛЫЖИ" && _selectedKindOfSport == name) ||
        (name == "СНОУБОРД" && _selectedKindOfSport == name);
  }

  Widget _instructorsListWidget() {
    return Container(
      height: screenHeight * 0.68,
      width: screenWidth * 0.95,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: ListView(
        children: _profileWidgets(_selectedKindOfSport == "СНОУБОРД"
            ? _snowboardInstructors
            : _skiesInstructors),
      ),

      ///Todo change here
      // child: CustomScrollView(
      //   primary: false,
      //   slivers: [
      //     SliverPadding(
      //       padding: const EdgeInsets.all(10),
      //       sliver: SliverGrid.count(
      //           mainAxisSpacing: 20,
      //           crossAxisCount: 2,
      //           children: _profileWidgets(_selectedKindOfSport == "СНОУБОРД"
      //               ? _snowboardInstructors
      //               : _skiesInstructors)),
      //     )
      //   ],
      // ),
    );
  }

  List<Widget> _profileWidgets(List<Instructor> instructors) {
    List<Widget> widgets = [];
    for (var i = 0; i < instructors.length; ++i) {
      widgets.add(_profileWidget(i, instructors));
    }
    return widgets;
  }

  Widget _profileWidget(int which, List<Instructor> instructors) {
    return GestureDetector(
      onTap: () => _openInstructorProfileScreen(instructors[which]),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InstructorPhotoWidget(instructors[which]),
            const SizedBox(width: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  instructors[which].name ?? "",
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  instructors[which].phone ?? "",
                  textAlign: TextAlign.center,
                  style:
                      const TextStyle(
                        color: kBlackLight,
                        fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openInstructorProfileScreen(Instructor instructor) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => InstructorProfileScreen(
          instructor,
        ),
      ),
    );
  }


  void _getInstructors() {
    _skiesInstructors =
        _instructorsKeeper.findInstructorsByKindOfSport(KindsOfSport.SKIES);
    _snowboardInstructors =
        _instructorsKeeper.findInstructorsByKindOfSport(KindsOfSport.SNOWBOARD);
  }
}

class KindsOfSport {
  // ignore: constant_identifier_names
  static const String SKIES = "Горные лыжи";
  // ignore: constant_identifier_names
  static const String SNOWBOARD = "Сноуборд";
}
