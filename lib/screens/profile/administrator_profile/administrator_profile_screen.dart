import 'package:academ_gora_release/screens/profile/administrator_profile/instructors_screen.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/news_add_screen.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/personal_screen.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../extension.dart';

class AdministratorProfileScreen extends StatefulWidget {
  const AdministratorProfileScreen({Key? key}) : super(key: key);

  @override
  _AdministratorProfileScreenState createState() =>
      _AdministratorProfileScreenState();
}

class _AdministratorProfileScreenState
    extends State<AdministratorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Column(
      children: [
        button(onTap: () {
            Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => const NewsAddScreen()));
      
        }, text: "Новости"),
        button(onTap: () {
            Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => const InstructorsScreen()));
      
        }, text: "Инструкторы"),
        button(onTap: 
        () {
            Navigator.of(context).push(
            MaterialPageRoute(builder: (c) => const PersonalScreeen()));
      
        }, text: "Персонал"),
      ],
    );
  }

  Widget button({required Function onTap, required String text}) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.1,
      margin: const EdgeInsets.only(top: 16),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
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
