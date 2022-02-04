import 'package:flutter/material.dart';

class AcademButton extends StatelessWidget {
  const AcademButton(
      {Key? key,
      required this.onTap,
      required this.tittle,
      required this.width})
      : super(key: key);
  final Function onTap;
  final String tittle;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: width,
        height: 45,
        decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Center(
          child: Text(
            tittle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }
}
