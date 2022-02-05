import 'package:academ_gora_release/core/components/buttons/admin_button.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/administrator_profile_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/settings/decorization/dedcorization.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/settings/news/news_add_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/settings/personal/personal_screen.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Настройи",
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
                children: [
                  buildButtons(),
                ],
              ),
              Positioned(
                  bottom: 32,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // cancelButton(), 
                      _backToMainScreenButton()],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Column(
      children: [
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const NewsAddScreen()));
            },
            text: "Новости"),
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const Decorzation()));
            },
            text: "Оформление"),
        AdminButton(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (c) => const PersonalScreeen()));
          },
          text: "Персонал",
        ),
      ],
    );
  }

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

  Widget cancelButton() {
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
                MaterialPageRoute(
                    builder: (c) => const AdministratorProfileScreen()),
                (route) => false);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Назад",
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

  Widget button({required Function onTap, required String text}) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.07,
      margin: const EdgeInsets.only(top: 16),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
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
