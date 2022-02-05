import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class ArchieveScreen extends StatefulWidget {
  const ArchieveScreen({Key? key}) : super(key: key);

  @override
  _ArchieveScreenState createState() => _ArchieveScreenState();
}

class _ArchieveScreenState extends State<ArchieveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Архив'",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Text("В разработке"),
                  )
                ],
              ),
              Positioned(
                bottom: 32,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // cancelButton(),
                    _backToMainScreenButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildButtons() {
  //   return Column(
  //     children: [
  //       AdminButton(
  //           onTap: () {
  //             Navigator.of(context).push(
  //                 MaterialPageRoute(builder: (c) => const NewsAddScreen()));
  //           },
  //           text: "Новости"),
  //       AdminButton(
  //           onTap: () {
  //             Navigator.of(context).push(
  //                 MaterialPageRoute(builder: (c) => const CurrentScreen()));
  //           },
  //           text: "Оформление"),
  //       AdminButton(
  //         onTap: () {
  //           Navigator.of(context).push(
  //               MaterialPageRoute(builder: (c) => const PersonalScreeen()));
  //         },
  //         text: "Персонал",
  //       ),
  //     ],
  //   );
  // }

  Widget _backToMainScreenButton() {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: kMainColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => const MainScreen()),
                (route) => false);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "НА ГЛАВНУЮ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
