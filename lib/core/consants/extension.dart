import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/all_instructors/all_instructors_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../main.dart';

String userLoggedToApp(String phone) {
  return "Пользователь $phone вошел в приложении";
}

String userRegisteredToApp(String phone) {
  return "Пользователь $phone зарегистрировался в приложении";
}

String userRegisteredForInstructor(String phone,
    {String date = "", String time = "", String instructorname = ''}) {
  return "Пользователь $phone записалься on $date и $time  к инструктору $instructorname";
}

String instructorOpenWorkout(String instructorName, String date, String time) {
  return "Инструктор $instructorName открыл занятие $date на $time";
}

String instructorCloseWorkout(String instructorName, String date, String time) {
  return "Инструктор $instructorName закрыл занятие $date на $time";
}

String userRegisterWorkout(
  String phone,
) {
  return "Пользователь $phone записалься на занятия";
}

String userCancekWorkout(
  String phone,
) {
  return "Пользователь $phone отменил  занятие";
}

String adminCancelWorkout(
    String adminPhone, String instructorName, String date, String time) {
  return "Администратор $adminPhone отменил занятие $instructorName на $date $time";
}

String adminOpenWorkout(
    String adminPhone, String instructorName, String date, String time) {
  return "Администратор $adminPhone открыл занятие $instructorName на $date $time";
}

String adminAddInstructor(String phone, String instructorName) {
  return "Администратор $phone добавил нового Инструктора $instructorName";
}

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
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Widget buildOneInputs({required TextEditingController controller}) {
  return _textFieldWidget(
    width: screenWidth * 0.5,
    textInputType: TextInputType.name,
    controller: controller,
  );
}

Widget _textFieldWidget(
    {required double width,
    required TextInputType textInputType,
    required TextEditingController controller}) {
  return Container(
    margin: const EdgeInsets.only(
      bottom: 16,
      left: 5,
      right: 5,
      top: 16,
    ),
    height: 30,
    width: width,
    child: TextField(
      onSubmitted: (s) {
        // {widget.registrationParametersScreenState.setState(() {})};
      },
      keyboardType: textInputType,
      controller: controller,
      style: const TextStyle(fontSize: 14),
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.only(left: 5, bottom: 5, top: 5, right: 5),
      ),
    ),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: const BorderRadius.all(
        Radius.circular(5),
      ),
    ),
  );
}

void showRoleChangeDialog(
    {required BuildContext context,
    required Function function,
    required String role}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Точно хотите поменять роль на \n\"$role\" ?",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: OutlinedButton(
                        child: const Text('ДА'),
                        onPressed: () {
                          function();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    OutlinedButton(
                      child: const Text('ОТМЕНА'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> showRoleChangeDialogWithInput(
    {required BuildContext context, required String role}) async {
  TextEditingController nameController = TextEditingController();
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Введите имя",
                textAlign: TextAlign.center,
              ),
              buildOneInputs(controller: nameController),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: OutlinedButton(
                        child: const Text('Сохранить'),
                        onPressed: () {
                          Navigator.of(context).pop(nameController.text);
                        },
                      ),
                    ),
                    OutlinedButton(
                      child: const Text('ОТМЕНА'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<Map?> showInstructorKindOfSportDialog(
    {required BuildContext context, required String role}) async {
  TextEditingController nameController = TextEditingController();
  String name = "";
  String kindOFSport = '';
  Map<String, String> param = {"name": name, "kindOfSport": kindOFSport};
  return await showDialog<Map>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Введите имя инструктора",
                textAlign: TextAlign.center,
              ),
              buildOneInputs(controller: nameController),
              const Text(
                "Выберите вид спорта",
                textAlign: TextAlign.center,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: OutlinedButton(
                        child: const Text(KindsOfSport.SKIES),
                        onPressed: () {
                          param["name"] = nameController.text;
                          param["kindOfSport"] = KindsOfSport.SKIES;
                          Navigator.of(context).pop(param);
                        },
                      ),
                    ),
                    OutlinedButton(
                      child: const Text(KindsOfSport.SNOWBOARD),
                      onPressed: () {
                        param["name"] = nameController.text;
                        param["kindOfSport"] = KindsOfSport.SNOWBOARD;
                        Navigator.of(context).pop(param);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

void showCancelDialog(BuildContext context, Function()? logoutFunction) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: SizedBox(
        height: screenHeight * 0.15,
        child: Column(
          children: [
            const Text("Вы точно хотите изменить?"),
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

void showDeleteNotifications(BuildContext context,
    {required Function()? confirmFunction,
    required Function()? cancelFunction}) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          content: SizedBox(
        height: screenHeight * 0.15,
        child: Column(
          children: [
            const Text("Вы точно хотите удалить?"),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: OutlinedButton(
                        child: const Text('ДА'), onPressed: confirmFunction),
                  ),
                  OutlinedButton(
                    child: const Text('ОТМЕНА'),
                    onPressed: cancelFunction,
                  ),
                ],
              ),
            )
          ],
        ),
      ));
    },
  );
}
