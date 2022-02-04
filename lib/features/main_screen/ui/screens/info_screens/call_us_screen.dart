import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/core/functions/functions.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class CallUsScreen extends StatefulWidget {
  const CallUsScreen({Key? key}) : super(key: key);

  @override
  _CallUsScreenState createState() => _CallUsScreenState();
}

class _CallUsScreenState extends State<CallUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "СВЯЗАТЬСЯ С АДМИНИСТРАЦИЕЙ",
            style: TextStyle(fontSize: 14),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: screenDecoration("assets/info_screens/call_us/bg.png"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  _callNumberButton(),
                  _whatsAppButton(),
                  _mailButton(),
                ],
              ),
              _logo(),
              AcademButton(
                tittle: 'НА ГЛАВНУЮ',
                onTap: () {
                  FunctionsConsts.openMainScreen(context);
                },
                width: screenWidth * 0.9,
                fontSize: 18,
              ),
            ],
          ),
        ));
  }

  Widget _callNumberButton() {
    return GestureDetector(
      onTap: () {
        callNumber("89025101513");
      },
      child: Container(
        height: screenHeight * 0.07,
        width: screenWidth * 0.8,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: screenWidth * 0.1),
        margin: EdgeInsets.only(top: screenHeight * 0.07),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: AssetImage("assets/info_screens/call_us/1.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          "+89025101513",
          style: TextStyle(
              fontSize: screenHeight * 0.04,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _whatsAppButton() {
    return GestureDetector(
      onTap: () {
        launchURL(whatsAppUrl("+79025101513"));
      },
      child: Container(
        height: screenHeight * 0.07,
        width: screenWidth * 0.8,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: screenWidth * 0.15),
        margin: EdgeInsets.only(top: screenHeight * 0.04),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: AssetImage("assets/info_screens/call_us/2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          "НАПИСАТЬ",
          style: TextStyle(
              fontSize: screenHeight * 0.04,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _mailButton() {
    return GestureDetector(
      onTap: () {
        writeEmail("Progress077@yandex.ru");
      },
      child: Container(
        height: screenHeight * 0.07,
        width: screenWidth * 0.8,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: screenWidth * 0.05),
        margin: EdgeInsets.only(top: screenHeight * 0.04),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          image: DecorationImage(
            image: AssetImage("assets/info_screens/call_us/3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          "Progress077@yandex.ru",
          style: TextStyle(
              fontSize: screenHeight * 0.025,
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.06),
      height: screenHeight * 0.25,
      width: screenWidth * 0.35,
      child: Image.asset("assets/info_screens/call_us/4.png"),
    );
  }
}
