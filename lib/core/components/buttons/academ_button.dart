import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';

class AcademButton extends StatelessWidget {
  const AcademButton(
      {Key? key,
      required this.onTap,
      required this.tittle,
      required this.width,
      required this.fontSize,
      this.height = 50,
      this.colorButton = kMainColor,
      this.colorText = kWhite,
      this.borderColor = Colors.transparent})
      : super(key: key);
  final Function onTap;
  final String tittle;
  final double width;
  final double fontSize;
  final double height;
  final Color colorButton;
  final Color colorText;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: colorButton,
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Text(
            tittle,
            textAlign: TextAlign.center,
            style: TextStyle(color: colorText, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
