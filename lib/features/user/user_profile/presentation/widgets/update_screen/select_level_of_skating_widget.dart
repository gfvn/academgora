import 'package:academ_gora_release/features/user/user_profile/presentation/screens/update_workout_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

import 'package:academ_gora_release/core/style/color.dart';

class SelectLevelOfSkatingWidget extends StatefulWidget {
  final int selectedLevelOfSkating;
  final UpdateWorkoutScreenState updateWorkoutScreenState;

  const SelectLevelOfSkatingWidget(
      this.selectedLevelOfSkating, this.updateWorkoutScreenState,
      {Key? key})
      : super(key: key);

  @override
  _SelectLevelOfSkatingWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _SelectLevelOfSkatingWidgetState(selectedLevelOfSkating);
}

class _SelectLevelOfSkatingWidgetState
    extends State<SelectLevelOfSkatingWidget> {
  int _selectedLevelOfSkating;

  _SelectLevelOfSkatingWidgetState(this._selectedLevelOfSkating);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _title(),
        _levelButtons(),
        _levelButton(
            2, screenWidth * 0.9, "Умею с любой горы, улучшение техники",
            rightMargin: screenWidth * 0.03)
      ],
    );
  }

  Widget _title() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(left: screenWidth * 0.03),
        child: const Text(
          "Выбор уровня катания:",
          style: TextStyle(fontSize: 12, color: kMainColor),
        ));
  }

  Widget _levelButtons() {
    return Container(
        margin: EdgeInsets.only(left: screenWidth * 0.03, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _levelButton(0, screenWidth * 0.33, "C нуля"),
            _levelButton(1, screenWidth * 0.52, "Немного умею", leftMargin: 20),
          ],
        ));
  }

  Widget _levelButton(int which, double width, String text,
      {double leftMargin = 0, double rightMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
      child: GestureDetector(
        onTap: () => _selectCount(which),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image:
                    AssetImage(_createBackgroundOfLevelOfSkatingButton(which)),
                fit: BoxFit.fill),
          ),
          height: screenHeight * 0.045,
          width: width,
          padding: const EdgeInsets.only(right: 8),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 14,
                color: which == _selectedLevelOfSkating
                    ? Colors.white
                    : Colors.black),
          ),
        ),
      ),
    );
  }

  void _selectCount(int which) {
    _selectedLevelOfSkating = which;
    widget.updateWorkoutScreenState.setState(() {
      widget.updateWorkoutScreenState.levelOfSkating = _selectedLevelOfSkating;
    });
    setState(() {});
  }

  String _createBackgroundOfLevelOfSkatingButton(int which) {
    return which == _selectedLevelOfSkating
        ? "assets/auth/e2.png"
        : "assets/registration_parameters/e_1.png";
  }
}
