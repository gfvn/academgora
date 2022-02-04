import 'dart:developer';

import 'package:academ_gora_release/core/api/auth_controller.dart';
import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/loader/loader_widget.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/core/data_keepers/user_workouts_keeper.dart';
import 'package:academ_gora_release/core/functions/functions.dart';
import 'package:academ_gora_release/core/notification/notification_api.dart';
import 'package:academ_gora_release/features/auth/ui/widgets/login_form.dart';
import 'package:academ_gora_release/core/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';
import '../../../../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //Variables and objects
  final AuthController _authController = AuthController();
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  bool isLoading = false;

  //Functions
  void auth() async {
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
      setState(
        () {
          isLoading = true;
        },
      );
      final token = await NotificationApi().setupNotification();
      await Future.delayed(const Duration(milliseconds: 3000));

      await _authController
          .saveUserRole(FirebaseAuth.instance.currentUser!.phoneNumber!, token)
          .then(
        (userRole) {
          if (userRole == UserRole.user) {
            _firebaseRequestsController.addListener(
                "Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия",
                _saveWorkoutsIntoUserDataKeeper);
          }
          setState(
            () {
              isLoading = false;
            },
          );
          FunctionsConsts.openMainScreen(context);
        },
      );
    } else {
      log(
        'resullt is bad',
      );
    }
  }

  void _saveWorkoutsIntoUserDataKeeper(Event? event) async {
    await _firebaseRequestsController
        .get("Пользователи/${FirebaseAuth.instance.currentUser!.uid}/Занятия")
        .then(
      (value) {
        UserWorkoutsKeeper().updateWorkouts(value);
        if (_firebaseRequestsController.myAppState != null) {
          _firebaseRequestsController.myAppState!.setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Container(
              width: screenWidth,
              decoration: screenDecoration("assets/auth/1_background.png"),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginFormWidget(),
                  AcademButton(
                    onTap: auth,
                    tittle: "Вход",
                    width: 200,
                    fontSize: 24,
                  ),
                ],
              ),
            )
          : const LoaderWidget(),
    );
  }
}
