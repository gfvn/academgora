import 'package:academ_gora_release/core/style/color.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  const AdminButton({Key? key, required this.onTap, required this.text}) : super(key: key);
  final Function onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: 50,
      margin: const EdgeInsets.only(top: 16),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: kMainColor,
        child: InkWell(
          onTap: () {
            onTap();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
