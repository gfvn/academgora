// ignore_for_file: deprecated_member_use

import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final double width;
  final double height;
  final double fontSize;
  final String title;
  final EdgeInsets margin;
  final Function()? onPressed;
  final Color textColor;
  final Color buttonColor;

  const MainButton(
      {required this.title,
      required this.width,
      required this.height,
      required this.fontSize,
      required this.margin,
      required this.onPressed,
      this.textColor = Colors.white,
      this.buttonColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: buttonColor,
          border: Border.all(color: kMainColor)),
      child: FlatButton(
        onPressed: onPressed,
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 1),
          child: Text(
            title,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
