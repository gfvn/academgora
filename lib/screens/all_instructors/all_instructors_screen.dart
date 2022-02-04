import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/screens/instructor_profile/instructor_profile_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/instructor_photo_widget.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../main.dart';
import '../../core/consants/extension.dart';
import '../../features/main_screen/ui/screens/main_screen/main_screen.dart';

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
        _kindOfSportButton("ГОРНЫЕ ЛЫЖИ"),
        _kindOfSportButton("СНОУБОРД"),
        _instructorsListWidget(),
        _backToMainScreenButton()
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
          width:
              _checkKindOfSport(name) ? screenWidth * 0.75 : screenWidth * 0.7,
          height: _checkKindOfSport(name)
              ? screenHeight * 0.06
              : screenHeight * 0.05,
          margin: const EdgeInsets.only(top: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(7)),
              color: _checkKindOfSport(name) ? kMainColor : Colors.white),
          child: Text(
            name,
            style: TextStyle(
                color: _checkKindOfSport(name) ? Colors.white : kMainColor,
                fontSize: _checkKindOfSport(name)
                    ? screenHeight * 0.034
                    : screenHeight * 0.03),
          ),
        ));
  }

  bool _checkKindOfSport(String name) {
    return (name == "ГОРНЫЕ ЛЫЖИ" && _selectedKindOfSport == name) ||
        (name == "СНОУБОРД" && _selectedKindOfSport == name);
  }

  Widget _instructorsListWidget() {
    return Container(
        height: screenHeight * 0.7,
        width: screenWidth * 0.78,
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        alignment: Alignment.center,
        child: CustomScrollView(
          primary: false,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverGrid.count(
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: _profileWidgets(_selectedKindOfSport == "СНОУБОРД"
                      ? _snowboardInstructors
                      : _skiesInstructors)),
            )
          ],
        ));
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
        child: Column(
          children: [
            InstructorPhotoWidget(instructors[which]),
            Text(
              instructors[which].name ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  void _openInstructorProfileScreen(Instructor instructor) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => InstructorProfileScreen(
              instructor,
            )));
  }

  Widget _backToMainScreenButton() {
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.05,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: kMainColor,
        child: InkWell(
            onTap: () => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => const MainScreen()),
                      (route) => false)
                },
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                     Text(
                      "НА ГЛАВНУЮ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ]),
            )),
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
