import 'package:flutter/material.dart';

import '../extension.dart';
import '../main_screen.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: screenDecoration("assets/info_screens/prices/bg.png"),
            child: Container(
                margin: EdgeInsets.all(10),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    _priceTitle(),
                    _table(),
                    _info(),
                    defaultButton('НА ГЛАВНУЮ', _openMainScreen),
                  ],
                ))));
  }

  Widget _priceTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 5),
      child: Text(
        "ПРАЙС",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _table() {
    return Container(margin: EdgeInsets.only(bottom: 10),
        child: Table(
      border: TableBorder.all(color: Colors.white, width: 2),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        _tableRow(
          "Наименование услуги",
          "1-й час",
          "Целый день",
          color: Colors.white,
        ),
        _tableRow("Горные лыжи или\nсноуборд", "400", "1100"),
        _tableRow("Беговые лыжи", "300", "750"),
        _tableRow("Детские горные лыжи\nили сноуборд", "300", "750"),
        _tableRow("Разовый подъем", "50", "50"),
        _tableRow("Абонемент на кресельный подъемник", "400", "1100"),
        _tableRow(
            "Лыжи или сноуборд\nбез ботинок, ботинки\nотдельно", "300", "950"),
        _tableRow("Въезд на территорию\n(1 въезд)", "100", "100"),
      ],
    ));
  }

  TableRow _tableRow(String text1, String text2, String text3,
      {Color color = Colors.transparent, double leftPadding = 10}) {
    return TableRow(
      children: <Widget>[
        _textInTable(text1, Alignment.centerLeft,
            color: color, leftPadding: leftPadding),
        _textInTable(text2, Alignment.center, color: color),
        _textInTable(text3, Alignment.center, color: color),
      ],
    );
  }

  Widget _textInTable(String text, Alignment alignment,
      {Color color = Colors.transparent, double leftPadding = 0}) {
    return Container(
        alignment: alignment,
        color: color,
        padding: EdgeInsets.only(left: leftPadding, top: 5, bottom: 5),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)));
  }

  Widget _info() {
    return Expanded(
      child: SingleChildScrollView(
          child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
              "1.Инвентарь выдается только при наличии паспорта или водительского удостоверения (один комплект – на один документ или денежный залог в размере 10 000 р.)\n"
              "2.После 20:00 инвентарь не выдается\n"
              "3.Работник проката вправе отказать в выдаче инвентаря без объяснения причин.\n"
              "Подробный прайс и другая полезная информация -  в нашей группе,\n",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            GestureDetector(
                onTap: () {
                  launchURL("https://vk.com/akademgora");
                },
                child: Text(
                  "https://vk.com/akademgora\n",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                )),
            Text(
              "Уважаемые гости. В нашем комплексе вы можете приобрести подарочные сертификаты на любую сумму и услуги комплекса. А также, есть возможность приобрести депозитный сертификат на любую сумму с возможностью частичного (не разового) использования на протяжении всего сезона.\n"
              "Сертификаты не обналичиваются. На оплату услуг парковки и буфета не распространяются.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ])),
    );
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => MainScreen()), (route) => false);
  }
}
