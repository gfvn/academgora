import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'controller/firebase_requests_controller.dart';
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
  final FirebaseRequestsController _firebaseController = FirebaseRequestsController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final UserWorkoutsKeeper _userDataKeeper = UserWorkoutsKeeper();
  bool? _isUserAuthorized;

  @override
  void initState() {
    super.initState();
    _firebaseController.myAppState = this;
    if (FirebaseAuth.instance.currentUser != null) {
      UserRole.getUserRole().then((userRole) => {
            if (userRole == UserRole.user)
              {
                _firebaseController.addListener(
                    "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
                    _saveWorkoutsIntoUserDataKeeper)
              }
          });
      setState(() {
        _isUserAuthorized = true;
      });
    } else {
      setState(() {
        _isUserAuthorized = false;
      });
    }
    _saveInstructorsIntoKeeper(null);
    _firebaseController.addListener("Инструкторы", _saveInstructorsIntoKeeper);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'АкадемГора',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(builder: (context) {
          screenHeight = MediaQuery.of(context).size.height;
          screenWidth = MediaQuery.of(context).size.width;
          if (_isUserAuthorized != null) {
            return _isUserAuthorized! ? const MainScreen() : const AuthScreen();
          } else {
            return const SplashScreen();
          }
        }));
  }

  void _saveInstructorsIntoKeeper(Event? event) async {
    await _firebaseController.get("Инструкторы").then((value) {
      _instructorsKeeper.updateInstructors(value);
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
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/account/0_bg.png"),
        fit: BoxFit.cover,
      ),
    )));
  }
}
