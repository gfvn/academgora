import 'package:flutter/material.dart';

class MainTextField extends StatelessWidget {
  const MainTextField(
      {Key? key,
      required this.width,
      required this.textInputType,
      required this.controller, required this.height})
      : super(key: key);
  final double width;
  final TextInputType textInputType;
  final TextEditingController controller;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
        left: 5,
        right: 5,
        top: 5,
      ),
      height: height,
      width: width,
      child: TextField(
        onSubmitted: (s) {
          // {widget.registrationParametersScreenState.setState(() {})};
        },
        keyboardType: textInputType,
        controller: controller,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }
}
