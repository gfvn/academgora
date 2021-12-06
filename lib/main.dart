import 'dart:developer';

import 'package:academ_gora_release/data_keepers/admin_keeper.dart';
import 'package:academ_gora_release/data_keepers/news_keeper.dart';
import 'package:academ_gora_release/data_keepers/user_keepaers.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'api/firebase_requests_controller.dart';
import 'data_keepers/instructors_keeper.dart';
import 'data_keepers/user_workouts_keeper.dart';
import 'model/user_role.dart';

late double screenHeight;
late double screenWidth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
  final UsersKeeper usersKeepers = UsersKeeper();

  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final UserWorkoutsKeeper _userDataKeeper = UserWorkoutsKeeper();
  final AdminKeeper _adminDataKeeper = AdminKeeper();
  final NewsKeeper _newsDataKeeper = NewsKeeper();

  bool? _isUserAuthorized;
  bool? _dataisloded = false;

  @override
  void initState() {
    super.initState();
    _firebaseController.myAppState = this;
    if (FirebaseAuth.instance.currentUser != null) {
      UserRole.getUserRole().then(
        (userRole) => {
          if (userRole == UserRole.user)
            {
              _firebaseController.addListener(
                  "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
                  _saveWorkoutsIntoUserDataKeeper)
            }
        },
      );
      setState(
        () {
          _isUserAuthorized = true;
        },
      );
    } else {
      setState(
        () {
          _isUserAuthorized = false;
        },
      );
    }
    _saveInstructorsIntoKeeper(null);
    _firebaseController.addListener("Инструкторы", _saveInstructorsIntoKeeper);

    _saveUsersIntoKeeper(null);
    _firebaseController.addListener("Пользователи", _saveUsersIntoKeeper);

    _saveAdminsIntoKeeper(null);
    _firebaseController.addListener("Администраторы", _saveAdminsIntoKeeper);

    _saveNewsrDataKeeper(null);
    _firebaseController.addListener("Новоти", _saveNewsrDataKeeper);
  }

  void isloded() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    setState(() {
      _dataisloded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'АкадемГора',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (context) {
          screenHeight = MediaQuery.of(context).size.height;
          screenWidth = MediaQuery.of(context).size.width;
          if (_isUserAuthorized != null) {
            if (_dataisloded!) {
              return _isUserAuthorized!
                  ? const MainScreen()
                  : const AuthScreen();
            } else {
              return const Scaffold();
            }
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }

  void _saveInstructorsIntoKeeper(Event? event) async {
    await _firebaseController.get("Инструкторы").then((value) {
      _instructorsKeeper.updateInstructors(value);
      setState(() {});
    });
  }

  void _saveUsersIntoKeeper(Event? event) async {
    await _firebaseController.get("Пользователи").then((value) {
      usersKeepers.updateInstructors(value);
      setState(() {});
    });
  }

  void _saveAdminsIntoKeeper(Event? event) async {
    await _firebaseController.get("Администраторы").then((value) {
      _adminDataKeeper.updateInstructors(value);
      setState(() {});
    });
  }

  void _saveWorkoutsIntoUserDataKeeper(Event? event) async {
    await _firebaseController
        .get("Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия")
        .then((value) {
      _userDataKeeper.updateWorkouts(value);
      setState(() {});
    });
  }

  void _saveNewsrDataKeeper(Event? event) async {
    await _firebaseController.getAsList('Новости').then((value) {
      log("Новости ${value.toString()}");
      _newsDataKeeper.updateInstructors(value);
      isloded();
      setState(() {});
    });
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/profile/0_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
