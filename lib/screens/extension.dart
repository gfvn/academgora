import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../main.dart';

extension DateOnlyCompare on DateTime {
  bool isAfterDate(DateTime other) {
    bool isDayAfter =
        year == other.year && month == other.month && day > other.day;
    bool isMonthAfter = year == other.year && month > other.month;
    bool isYearAfter = year > other.year;
    return isDayAfter || isMonthAfter || isYearAfter;
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBeforeDate(DateTime other) {
    bool isDayBefore =
        year == other.year && month == other.month && day < other.day;
    bool isMonthBefore = year == other.year && month < other.month;
    bool isYearBefore = year < other.year;
    return isDayBefore || isMonthBefore || isYearBefore;
  }
}

Widget defaultButton(String text, Function()? onPressed,
    {double width = 200, double height = 45}) {
  return Container(
      margin: const EdgeInsets.all(2),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 18),
          fixedSize: Size(width, height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ));
}

String whatsAppUrl(String phoneNumber) {
  return "https://wa.me/$phoneNumber";
}

Decoration screenDecoration(String path) {
  return BoxDecoration(
    image: DecorationImage(
      image: AssetImage(path),
      fit: BoxFit.cover,
    ),
  );
}

List months = [
  'Января',
  'Февраля',
  'Марта',
  'Апреля',
  'Мая',
  'Июня',
  'Июля',
  'Августа',
  'Сентября',
  'Октября',
  'Ноября',
  'Декабря'
];

List weekdays = [
  'ПН',
  'ВТ',
  'СР',
  'ЧТ',
  'ПТ',
  'СБ',
  'ВС',
];

void launchURL(String url) async =>
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

Widget phoneNumberForCallWidget(String phoneNumber, {TextStyle? textStyle}) {
  return GestureDetector(
    onTap: () {
      callNumber(phoneNumber);
    },
    child: Text(
      phoneNumber,
      style: textStyle,
    ),
  );
}

void writeEmail(String address) async {
  final Email email = Email(
    recipients: [address],
  );
  await FlutterEmailSender.send(email);
}

callNumber(String phoneNumber) async {
  String number = phoneNumber;
  await FlutterPhoneDirectCaller.callNumber(number);
}

void showLogoutDialog(BuildContext context, Function()? logoutFunction) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: SizedBox(
        height: screenHeight * 0.15,
        child: Column(
          children: [
            const Text("Выйти из аккаунта?"),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: OutlinedButton(
                          child: const Text('ДА'), onPressed: logoutFunction),
                    ),
                    OutlinedButton(
                      child: const Text('ОТМЕНА'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ))
          ],
        ),
      ));
    },
  );
}
