import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

import '../../registration_first_screen.dart';

class SelectKindOfSportWidget extends StatefulWidget {
  final int kindOfSport;
  final RegistrationFirstScreenState registrationToInstructorScreenState;

  const SelectKindOfSportWidget(
      this.registrationToInstructorScreenState, this.kindOfSport,
      {Key? key})
      : super(key: key);

  @override
  _SelectKindOfSportWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _SelectKindOfSportWidgetState(kindOfSport);
}

class _SelectKindOfSportWidgetState extends State<SelectKindOfSportWidget> {
  int _kindOfSport;

  _SelectKindOfSportWidgetState(this._kindOfSport);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _topImages(),
        _kindOfSportButtons(),
      ],
    );
  }

  Widget _topImages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _kindOfSportImage("assets/registration_to_instructor/2_ski.png"),
        _kindOfSportImage(
          "assets/registration_to_instructor/2_snowboard.png",
        )
      ],
    );
  }

  Widget _kindOfSportImage(String imagePath, {double marginLeft = 0}) {
    return Container(
      margin: EdgeInsets.only(top: 15, left: marginLeft),
      alignment: Alignment.center,
      child: Image.asset(
        imagePath,
        height: screenWidth * 0.45,
        width: screenWidth * 0.45,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _kindOfSportButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_kindOfSportButton(0), _kindOfSportButton(1, leftMargin: 40)],
    );
  }

  Widget _kindOfSportButton(int which, {double leftMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin),
      child: GestureDetector(
        onTap: () => _selectKindOfSport(which),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(_createBackgroundOfKindOfSportButton(which)),
              fit: BoxFit.fill,
            ),
          ),
          height: screenHeight * 0.06,
          width: screenWidth * 0.4,
          padding: const EdgeInsets.only(right: 12, left: 12),
          alignment: Alignment.centerRight,
          child: Text(
            which == 0 ? "ГОРНЫЕ ЛЫЖИ" : "СНОУБОРД",
            style: TextStyle(
                fontSize: 11,
                color: which == _kindOfSport ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _selectKindOfSport(int which) {
    _kindOfSport = which;
    widget.registrationToInstructorScreenState.setState(() {
      widget.registrationToInstructorScreenState.kindOfSport = _kindOfSport;
    });
    setState(() {});
  }

  String _createBackgroundOfKindOfSportButton(int which) {
    return which == _kindOfSport
        ? "assets/registration_to_instructor/3_e2.png"
        : "assets/registration_to_instructor/3_e1.png";
  }
}
