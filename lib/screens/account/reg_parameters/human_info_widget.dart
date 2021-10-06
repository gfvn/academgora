import 'package:academ_gora_release/screens/registration_to_workout/registration_parameters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../main.dart';
import '../update_workout_screen.dart';

class HumanInfoWidget extends StatefulWidget {
  final int which;
  final List<Pair> textEditingControllers;
  final UpdateWorkoutScreenState updateWorkoutScreenState;

  const HumanInfoWidget(this.which, this.textEditingControllers,
      this.updateWorkoutScreenState,
      {Key? key})
      : super(key: key);

  @override
  _HumanInfoWidgetState createState() => _HumanInfoWidgetState();
}

class _HumanInfoWidgetState extends State<HumanInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _numberOfPersonWidget(),
        _titleWidget("Имя"),
        _textFieldWidget(screenWidth * 0.35, 50, TextInputType.name),
        _titleWidget("Возраст"),
        _textFieldWidget(screenWidth * 0.14, 3, TextInputType.number)
      ],
    );
  }

  Widget _numberOfPersonWidget() {
    return Text(
      widget.which.toString(),
      style: TextStyle(
          color: Colors.grey,
          fontSize: screenHeight * 0.025,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _titleWidget(String text) {
    return Container(
        margin: EdgeInsets.only(left: 8.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.blue),
        ));
  }

  Widget _textFieldWidget(
      double width, int maxLength, TextInputType textInputType) {
    return Container(
      margin: EdgeInsets.only(bottom: 3, left: 10),
      height: screenHeight * 0.04,
      width: width,
      child: TextField(
        onSubmitted: (s) =>
            {widget.updateWorkoutScreenState.setState(() {})},
        keyboardType: textInputType,
        inputFormatters: [
          LengthLimitingTextInputFormatter(maxLength),
        ],
        controller: maxLength == 3
            ? widget.textEditingControllers[widget.which - 1].right
            : widget.textEditingControllers[widget.which - 1].left,
        style: TextStyle(fontSize: screenHeight * 0.025),
        decoration: new InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(left: 5, bottom: 2, top: 2, right: 5),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(5))),
    );
  }
}
