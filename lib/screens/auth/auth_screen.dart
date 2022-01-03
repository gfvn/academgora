import 'dart:developer';

import 'package:academ_gora_release/api/auth_controller.dart';
import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/data_keepers/user_workouts_keeper.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import '../../main.dart';
import '../extension.dart';
import '../main_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthController _authController = AuthController();
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Container(
              width: screenWidth,
              decoration: screenDecoration("assets/auth/1_background.png"),
              child: _loginForm(),
            )
          : const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            ),
    );
  }

  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("СК \"АКАДЕМИЧЕСКИЙ\"",
            style: TextStyle(
              fontSize: 20,
            )),
        _getCodeButton(),
      ],
    );
  }

  Widget _getCodeButton() {
    return GestureDetector(
        onTap: _auth,
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          width: 200,
          height: 45,
          decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: const Center(
              child: Text(
            "Вход",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24),
          )),
        ));
  }

  void _auth() async {
    final providers = [
      AuthUiProvider.phone,
    ];

    final result = await FlutterAuthUi.startUi(
      items: providers,
      tosAndPrivacyPolicy: TosAndPrivacyPolicy(
        tosUrl:
            "https://www.freeprivacypolicy.com/live/b5c4dfd8-1054-4f45-a2d1-688ec52b2d6f",
        privacyPolicyUrl:
            "https://www.freeprivacypolicy.com/live/b5c4dfd8-1054-4f45-a2d1-688ec52b2d6f",
      ),
      androidOption: const AndroidOption(
        enableSmartLock: false, // default true
        showLogo: true, // default false
        overrideTheme: true, // default false
      ),
      emailAuthOption: const EmailAuthOption(
        requireDisplayName: true,
        enableMailLink: false,
        handleURL: '',
        androidPackageName: '',
        androidMinimumVersion: '',
      ),
    );
    if (result) {
      setState(() {
        isLoading = true;
      });
      final token = await setupNotification();
      await Future.delayed(const Duration(milliseconds: 3000));

      await _authController
          .saveUserRole(FirebaseAuth.instance.currentUser!.phoneNumber!, token)
          .then((userRole) {
        print(FirebaseAuth.instance.currentUser!.phoneNumber!);
        if (userRole == UserRole.user) {
          _firebaseRequestsController.addListener(
              "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
              _saveWorkoutsIntoUserDataKeeper);
        }
        setState(() {
          isLoading = false;
        });
        _openMainScreen();
      });
    } else {
      log('resullt is bad');
    }
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }

  void _saveWorkoutsIntoUserDataKeeper(Event? event) async {
    await _firebaseRequestsController
        .get("Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия")
        .then((value) {
      UserWorkoutsKeeper().updateWorkouts(value);
      if (_firebaseRequestsController.myAppState != null) {
        _firebaseRequestsController.myAppState!.setState(() {});
      }
    });
  }
}
