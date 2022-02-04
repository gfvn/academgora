import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';

class AcademButton extends StatelessWidget {
  const AcademButton(
      {Key? key,
      required this.onTap,
      required this.tittle,
      required this.width,
      required this.fontSize})
      : super(key: key);
  final Function onTap;
  final String tittle;
  final double width;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: width,
        height: 50,
        decoration: const BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Text(
            tittle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: fontSize),
          ),
        ),
      ),
    );
  }
}
