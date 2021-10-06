import 'package:academ_gora_release/controller/auth_controller.dart';
import 'package:academ_gora_release/controller/firebase_requests_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: screenWidth,
      decoration: screenDecoration("assets/auth/1_background.png"),
      child: _loginForm(),
    ));
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
        tosUrl: "https://www.google.com",
        privacyPolicyUrl: "https://www.google.com",
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
    if (result){
      await _authController.saveUserRole(FirebaseAuth.instance.currentUser!.phoneNumber!).then((userRole) {
        if (userRole == UserRole.user) {
          _firebaseRequestsController.addListener(
              "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
              _saveWorkoutsIntoUserDataKeeper);
        }
        _openMainScreen();
      });
    }
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()), (route) => false);
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
