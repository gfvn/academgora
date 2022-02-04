import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';

final ThemeData appThemeData = ThemeData(
  appBarTheme: const AppBarTheme(backgroundColor: kMainColor),
  fontFamily: 'Montserrat',
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: kViolet,
    selectionColor: kVioletVeryPale,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(
        color: kWhite,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      primary: kViolet,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: kBlackLight,
    ),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: kBlack,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    bodyText1: TextStyle(
      color: kBlackLight,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    subtitle1: TextStyle(
      color: kBlack,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
    button: TextStyle(
      color: kWhite,
      fontSize: 10,
      fontWeight: FontWeight.w500,
    ),
  ),
);