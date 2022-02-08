import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/components/loader/loader_widget.dart';
import 'package:academ_gora_release/core/components/others/logo.dart';
import 'package:academ_gora_release/core/data_keepers/admin_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/cancel_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/news_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/notification_api.dart';
import 'package:academ_gora_release/core/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/user_keepaers.dart';
import 'package:academ_gora_release/core/data_keepers/user_workouts_keeper.dart';
import 'package:academ_gora_release/core/notification/notification_api.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:academ_gora_release/features/auth/ui/screens/auth_screen.dart';
import 'package:academ_gora_release/features/auth/ui/screens/splash_screen.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'core/user_role.dart';

//screenSizedApp
late double screenHeight;
late double screenWidth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp();
  NotificationApi().setupNotification();
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
  //Variables and objects
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
    // _saveUsersIntoKeeper(null);
    // _firebaseController.addListener("Пользователи", _saveUsersIntoKeeper);

    _saveAdminsIntoKeeper(null);
    // _firebaseController.addListener("Администраторы", _saveAdminsIntoKeeper);

    _saveInstructorsIntoKeeper(null);
    // _firebaseController.addListener("Инструкторы", _saveInstructorsIntoKeeper);

    _saveNewsrDataKeeper(null);
    // _firebaseController.addListener("Новоти", _saveNewsrDataKeeper);

    _saveCancelsIntoDataKeeper(null);
    // _firebaseController.addListener("Отмена", _saveCancelsIntoDataKeeper);

    _savePriceInDataKeeper(null);
  }

//Functions anm methods
  void isloded() async {
    setState(
      () {
        _dataisloded = true;
      },
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
    await _firebaseController.getAsList('Новости').then((value) async {
      _newsDataKeeper.updateInstructors(value);

      setState(() {});
    });
    await Future.delayed(const Duration(milliseconds: 3000));
    isloded();
  }

  void _savePriceInDataKeeper(Event? event) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('price') ?? ['0', '0', '0', '0'];
    _priceDataKeeper.updateWorkouts(list);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      title: 'АкадемГора',
      theme: ThemeData(
        primaryColor: kMainColor,
        appBarTheme: const AppBarTheme(backgroundColor: kMainColor),
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
                        children: const [
                          LogoWidget(),
                          SizedBox(
                            height: 16,
                          ),
                          LoaderWidget(),
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
}
