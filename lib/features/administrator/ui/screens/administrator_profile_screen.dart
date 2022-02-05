import 'package:academ_gora_release/core/components/buttons/admin_button.dart';
import 'package:academ_gora_release/core/components/dialogs/cancel_dialog.dart';
import 'package:academ_gora_release/core/components/dialogs/dialogs.dart';
import 'package:academ_gora_release/features/auth/ui/screens/auth_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/classes/classes_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/instructors/instructors_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/settings/settings_screen.dart';
import 'package:academ_gora_release/features/administrator/ui/screens/smeta/smeta_screen.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:academ_gora_release/core/style/color.dart';

import '../../../../main.dart';
import '../../../../core/consants/extension.dart';

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
      appBar: AppBar(
        title: const Text("Администратор"),
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
                    children: [_backToMainScreenButton(), _logoutButton()],
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
        // button(
        //     onTap: () {
        //       Navigator.of(context).push(
        //           MaterialPageRoute(builder: (c) => const NewsAddScreen()));
        //     },
        //     text: "Новости"),
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const InstructorsScreen()));
            },
            text: "Инструкторы"),
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const SettingsScreen()));
            },
            text: "Настройки"),
        // AdminButton(
        //     onTap: () {
        //       Navigator.of(context).push(
        //           MaterialPageRoute(builder: (c) => const PersonalScreeen()));
        //     },
        //     text: "Персонал"),
        AdminButton(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => const SmetaScreen()));
            },
            text: "Смета"),
        AdminButton(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (c) => const ClassesScreen()));
            },
            text: "Занятия"),
      ],
    );
  }

  void _logout() async {
    FirebaseAuth.instance.currentUser!.delete;
    FlutterAuthUi.signOut();
    var pref = await SharedPreferences.getInstance();
    pref.remove("userRole");
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (c) => const AuthScreen()),
      (route) => false,
    );
  }

  Widget _logoutButton() {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.only(top: 5),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.red,
        child: InkWell(
          onTap: () {
            Dialogs.showUnmodal(
              context,
              CancelDialog(
                title: "ВЫХОД",
                text: "Вы действительно хотите выйти ?",
                onAcept: () {
                  _logout();
                },
              ),
            );
            // showLogoutDialog(context, _logout);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "ВЫЙТИ",
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
