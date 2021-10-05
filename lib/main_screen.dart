import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_auth_ui/flutter_auth_ui.dart';

import 'auth_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Messages count: ',
            ),
            const Text(
              'FirebaseMessages count: ',
            ),
            MaterialButton(
                child: const Text("Get Firebase Data"),
                onPressed: () async {
                  DataSnapshot? messages = await FirebaseDatabase.instance
                      .reference().child('Инструкторы').get();
                  print((messages!.value as Map<Object?, Object?>).length);
                }),
            MaterialButton(
                child: const Text("logout"),
                onPressed: () async {
                  FlutterAuthUi.signOut().then((value) =>
                      () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (c) => const AuthScreen()), (
                        route) => false);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
