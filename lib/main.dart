import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/extension.dart';
import 'package:academ_gora_release/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'controller/firebase_requests_controller.dart';
import 'controller/notification_service.dart';
import 'data_keepers/instructors_keeper.dart';
import 'data_keepers/user_workouts_keeper.dart';
import 'model/user_role.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

late double screenHeight;
late double screenWidth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterBackgroundService.initialize(onStart);
  runApp(const MyApp());
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();
  service.setForegroundMode(true);
  Firebase.initializeApp().then((value){
    FirebaseRequestsController()
        .addListenerForAddAndChangeOperations("Log", showNotification);
  });
}

void showNotification(Event? event) {
  var value = event!.snapshot.value;
  var currentUserPhone = FirebaseAuth.instance.currentUser!.phoneNumber!;
  if (value == userCancelledWorkoutForInstructor(currentUserPhone)) {
    NotificationApi.showNotification(
        title: "Гость отменил занятие", body: "", payload: "cancelled_workout");
  }

  if (value.toString().startsWith("user registered") &&
      value.toString().contains(currentUserPhone)) {
    String date = value.toString().split(" ")[3];
    String parsedDate = date.substring(0, 2) +
        "." +
        date.substring(2, 4) +
        "." +
        date.substring(4, 8);
    String time = value.toString().split(" ")[5];
    NotificationApi.showNotification(
        title: "Запись на $parsedDate - $time",
        body: "",
        payload: "registered_workout");
  }

  if (value.toString().startsWith("administrator cancelled") &&
      value.contains(currentUserPhone)) {
    int notificationId =
        int.parse(value.toString().split(';')[1].split('=')[1].substring(0, 7));
    NotificationApi.showNotification(
        title: "Администратор отменил занятие",
        body: "",
        payload: "admin_cancelled_workout");
    NotificationApi.cancelNotification(notificationId);
  }
  FirebaseRequestsController().delete("Log");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final FirebaseRequestsController _firebaseController =
      FirebaseRequestsController();
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
