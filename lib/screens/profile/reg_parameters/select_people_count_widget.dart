import 'package:academ_gora_release/screens/registration_to_workout/registration_parameters_screen.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../../main.dart';
import '../update_workout_screen.dart';

class SelectPeopleCountWidget extends StatefulWidget {
  final int selectedCount;
  final UpdateWorkoutScreenState updateWorkoutScreenState;

  const SelectPeopleCountWidget(
      this.selectedCount, this.updateWorkoutScreenState,
      {Key? key})
      : super(key: key);

  @override
  _SelectPeopleCountWidgetState createState() =>
      // ignore: no_logic_in_create_state
      _SelectPeopleCountWidgetState(selectedCount);
}

class _SelectPeopleCountWidgetState extends State<SelectPeopleCountWidget> {
  int _selectedCount;

  _SelectPeopleCountWidgetState(this._selectedCount);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _peoplesCountWidget(),
        _countButtons(),
      ],
    );
  }

  Widget _peoplesCountWidget() {
    return Container(
        margin: EdgeInsets.only(left: screenWidth * 0.03),
        child: const Text(
          "Количество человек",
          style: TextStyle(fontSize: 12, color: kMainColor),
        ));
  }

  Widget _countButtons() {
    return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _countButton(1),
            _countButton(2, leftMargin: 10),
            _countButton(3, leftMargin: 10),
            _countButton(4, leftMargin: 10)
          ],
        ));
  }

  Widget _countButton(int which, {double leftMargin = 0}) {
    return Container(
      margin: EdgeInsets.only(left: leftMargin),
      child: GestureDetector(
        onTap: () => _selectCount(which),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            image: DecorationImage(
                image: AssetImage(_createBackgroundOfCountButton(which)),
                fit: BoxFit.fill),
          ),
          height: screenHeight * 0.045,
          width: screenHeight * 0.045,
          alignment: Alignment.center,
          child: Text(
            which.toString(),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: which == _selectedCount ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _selectCount(int which) {
    _selectedCount = which;
    widget.updateWorkoutScreenState.setState(() {
      widget.updateWorkoutScreenState.peopleCount = _selectedCount;
      if (widget.updateWorkoutScreenState.textEditingControllers.isEmpty) {
        widget.updateWorkoutScreenState.textEditingControllers = [];
        for (var i = 0; i < which; ++i) {
          widget.updateWorkoutScreenState.textEditingControllers
              .add(Pair(TextEditingController(), TextEditingController()));
        }
      } else {
        for (var i =
                widget.updateWorkoutScreenState.textEditingControllers.length;
            i < which;
            ++i) {
          widget.updateWorkoutScreenState.textEditingControllers
              .add(Pair(TextEditingController(), TextEditingController()));
        }
      }
    });
    setState(() {});
  }

  String _createBackgroundOfCountButton(int which) {
    return which == _selectedCount
        ? "assets/registration_parameters/e_4.png"
        : "assets/registration_parameters/e_1.png";
  }
}
