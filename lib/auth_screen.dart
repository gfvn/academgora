import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
                child: const Text("Login"),
                onPressed: () {
                  _auth();
                }),
            MaterialButton(child: const Text("Logout"), onPressed: () {}),
          ],
        ),
      ),
    );
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
  }
}
