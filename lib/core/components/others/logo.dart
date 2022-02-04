import 'package:flutter/material.dart';

import '../../../main.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.06),
      height: screenHeight * 0.25,
      width: screenWidth * 0.35,
      child: Image.asset("assets/info_screens/call_us/4.png"),
    );
  }
}