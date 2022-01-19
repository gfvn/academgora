import 'dart:developer';

import 'package:academ_gora_release/api/auth_controller.dart';
import 'package:academ_gora_release/data_keepers/admin_keeper.dart';
import 'package:academ_gora_release/data_keepers/cancel_keeper.dart';
import 'package:academ_gora_release/data_keepers/news_keeper.dart';
import 'package:academ_gora_release/data_keepers/notification_api.dart';
import 'package:academ_gora_release/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/data_keepers/user_keepaers.dart';
import 'package:academ_gora_release/screens/auth/auth_screen.dart';
import 'package:academ_gora_release/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'api/firebase_requests_controller.dart';
import 'data_keepers/instructors_keeper.dart';
import 'data_keepers/user_workouts_keeper.dart';
import 'model/user_role.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<String> setupNotification() async {
  String token = '';
  void setToken(String? token) {
    log('FCM Token: $token');
  }

  Stream<String> _tokenStream;
  await Firebase.initializeApp();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.instance.requestPermission();
  token = await FirebaseMessaging.instance.getToken() ?? "no token";
  setToken(token);
  _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
  _tokenStream.listen(setToken);
  return token;
}

late double screenHeight;
late double screenWidth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  if (await UserRole.isFiresOpen()) {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.currentUser?.delete;
    }

    UserRole.changeIsFirst();
  }
  runApp(
    const MyApp(),
  );
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
  final CancelKeeper _cancelKeeper = CancelKeeper();
  final PriceKeeper _priceDataKeeper = PriceKeeper();

  bool? _isUserAuthorized;
  bool? _dataisloded = false;

  @override
  void initState() {
    super.initState();
    _firebaseController.myAppState = this;
    UserRole.checkUserAuth().then(
      (value) {
        if (value) {
          if (FirebaseAuth.instance.currentUser != null) {
            UserRole.getUserRole().then(
              (userRole) {
                return {
                  if (userRole == UserRole.user)
                    {
                      _firebaseController.addListener(
                        "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
                        _saveWorkoutsIntoUserDataKeeper,
                      )
                    }
                  else if (userRole == UserRole.administrator)
                    {}
                };
              },
            );
            setState(
              () {
                _isUserAuthorized = true;
              },
            );
          }
        }
      },
    );
    setState(
      () {
        _isUserAuthorized = false;
      },
    );
    _saveUsersIntoKeeper(null);
    // _firebaseController.addListener("Пользователи", _saveUsersIntoKeeper);

    _saveAdminsIntoKeeper(null);
    // _firebaseController.addListener("Администраторы", _saveAdminsIntoKeeper);

    _saveInstructorsIntoKeeper(null);
    _firebaseController.addListener("Инструкторы", _saveInstructorsIntoKeeper);

    _saveNewsrDataKeeper(null);
    _firebaseController.addListener("Новоти", _saveNewsrDataKeeper);

    _saveCancelsIntoDataKeeper(null);
    // _firebaseController.addListener("Отмена", _saveCancelsIntoDataKeeper);

    _savePriceInDataKeeper(null);
  }

  void isloded() async {
    setState(() {
      _dataisloded = true;
    });
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.only(top: screenHeight * 0.06),
      height: screenHeight * 0.25,
      width: screenWidth * 0.35,
      child: Image.asset("assets/info_screens/call_us/4.png"),
    );
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
              return Scaffold(
                body: Stack(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _logo(),
                          const SizedBox(
                            height: 16,
                          ),
                          const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const SplashScreen();
          }
        },
      ),
    );
  }

  void _saveInstructorsIntoKeeper(Event? event) async {
    await _firebaseController.get("Инструкторы").then(
      (value) {
        _instructorsKeeper.updateInstructors(value);
        setState(() {});
      },
    );
  }

  void _saveCancelsIntoDataKeeper(Event? event) async {
    await _firebaseController.get("Отмена").then(
      (value) {
        _cancelKeeper.updateInstructors(value);
        setState(() {});
      },
    );
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

  void _savePriceInDataKeeper(Event? event) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('price') ?? ['0', '0', '0', '0'];
    _priceDataKeeper.updateWorkouts(list);
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
