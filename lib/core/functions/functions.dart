import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class FunctionsConsts {
  static void openMainScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (c) => const MainScreen(),
      ),
      (route) => false,
    );
  }

  static void openPushScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (c) => screen,
      ),
    );
  }
}
