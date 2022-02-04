import 'package:academ_gora_release/core/components/buttons/admin_button.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/features/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/administrator_profile_screen.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/decor_screen/about_us_settings.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/decor_screen/chill_zone_settings.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/decor_screen/contact_us_settings.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/decor_screen/price_setting.dart';
import 'package:academ_gora_release/screens/profile/administrator_profile/decor_screen/work_time_setting.dart';

import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class Decorzation extends StatefulWidget {
  const Decorzation({Key? key}) : super(key: key);

  @override
  _DecorzationState createState() => _DecorzationState();
}

class _DecorzationState extends State<Decorzation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Оформление приложение",
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
                      _backToMainScreenButton()
                    ],
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
                  MaterialPageRoute(builder: (c) => const PriceSetting()));
            },
            text: "Прайс"),
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const WorkTimeSetting()));
            },
            text: "Режим работы"),
        AdminButton(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => const ChillZoneSettings()));
          },
          text: "Зона отдыха",
        ),
        AdminButton(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => const AboutUsSettings()));
          },
          text: "О нас",
        ),
        AdminButton(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (c) => const ContactUsSettings()));
          },
          text: "Связаться с нами",
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
