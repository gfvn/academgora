import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/profile/instructor_profile/instructor_workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import '../../../main.dart';
import '../../extension.dart';
import '../../main_screen.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({Key? key}) : super(key: key);

  @override
  _InstructorsScreenState createState() =>
      _InstructorsScreenState();
}

class _InstructorsScreenState
    extends State<InstructorsScreen> {
  String _selectedKindOfSport = "ГОРНЫЕ ЛЫЖИ";

  List<Instructor> _snowboardInstructors = [];
  List<Instructor> _skiesInstructors = [];

  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();

  @override
  Widget build(BuildContext context) {
    _getInstructors();
    return Scaffold(
      body: Container(
          decoration: screenDecoration("assets/all_instructors/bg.png"),
          child: Center(
            child: _instructorsList(),
          )),
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
          _backToMainScreenButton(),
          _logoutButton()
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
              color: _checkKindOfSport(name) ? Colors.blue : Colors.white),
          child: Text(
            name,
            style: TextStyle(
                color: _checkKindOfSport(name) ? Colors.white : Colors.blue,
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
        height: screenHeight * 0.65,
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
        onTap: () => _openInstructorWorkoutsScreen(instructors[which]),
        child: Column(
            children: [
              SizedBox(
                width: screenWidth * 0.3,
                height: screenHeight * 0.13,
                child: Image.asset("assets/all_instructors/2.png"),
              ),
              Text(
                instructors[which].name!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
  }

  void _openInstructorWorkoutsScreen(Instructor instructor){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => InstructorWorkoutsScreen(instructorPhoneNumber: instructor.phone)));
  }

  Widget _backToMainScreenButton() {
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.05,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: () => {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => MainScreen()),
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

  Widget _logoutButton() {
    return Container(
      width: screenWidth * 0.4,
      height: screenHeight * 0.05,
      margin: const EdgeInsets.only(top: 5),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: () {
              showLogoutDialog(context, _logout);
            },
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ВЫЙТИ",
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

  void _logout() async {
    FlutterAuthUi.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (c) => const AuthScreen()),
            (route) => false);
  }

  void _getInstructors() {
    _skiesInstructors =
        _instructorsKeeper.findInstructorsByKindOfSport(KindsOfSport.SKIES);
    _snowboardInstructors =
        _instructorsKeeper.findInstructorsByKindOfSport(KindsOfSport.SNOWBOARD);
  }
}

class KindsOfSport {
  static const String SKIES = "Горные лыжи";
  static const String SNOWBOARD = "Сноуборд";
}
