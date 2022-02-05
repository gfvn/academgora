import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';

import '../main_screen/main_screen.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Прайс"),
        centerTitle: true,
      ),
      body: Container(
        decoration: screenDecoration("assets/info_screens/prices/bg.png"),
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10, bottom: 10, top:0),
          child: Flex(
            direction: Axis.vertical,
            children: [
              _priceTitle(),
              _pricePriceInfo(),
              _table(),
              _info(),
              AcademButton(
                tittle: 'НА ГЛАВНУЮ',
                onTap: _openMainScreen,
                width: screenWidth*0.9,
                fontSize: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceTitle() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 5),
      child: const Text(
        "ПРАЙС",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _pricePriceInfo() {
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Будни / ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            "Выходные и праздничные дни",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _table() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            "",
            "",
            color: Colors.white,
          ),
          // _tableMainRow("Будни / ", "Выходные и праздничные дни"),
          _tableRow(
              "Горные лыжи или\nсноуборд", "400 / ", "1100 / ", '400', '1100'),
          _tableRow("Беговые лыжи", "300 / ", "750 / ", "300", "750"),
          _tableRow("Детские горные лыжи\nили сноуборд", "300 / ", "750 / ",
              "300", "750"),
          _tableRow("Разовый подъем", "50 / ", "50 / ", "60", "60"),
          _tableRow("Абонемент на кресельный \nподъемник", "400 / ", "1100 / ",
              "500", "1400"),
          _tableRow("Абонемент на детский \nподъемник BabyLift", "200 / ",
              "600 / ", "250", "750"),
          _tableRow("Лыжи или сноуборд\nбез ботинок, ботинки\nотдельно",
              "300 / ", "950 / ", "300", "950"),
          _tableRow("Въезд на территорию\n(1 въезд)", "100 / ", "100 / ", "100",
              "100"),
        ],
      ),
    );
  }

  TableRow _tableRow(String text1, String text2, String text3,
      String holidayOnePrice, String holidayAllPrice,
      {Color color = Colors.transparent, double leftPadding = 10}) {
    return TableRow(
      children: <Widget>[
        _textInTable(
          text1,
          Alignment.centerLeft,
          '',
          MainAxisAlignment.start,
          color: color,
          leftPadding: leftPadding,
        ),
        _textInTable(
            text2, Alignment.center, holidayOnePrice, MainAxisAlignment.center,
            color: color),
        _textInTable(
            text3, Alignment.center, holidayAllPrice, MainAxisAlignment.center,
            color: color),
      ],
    );
  }


  Widget _textInTable(String text, Alignment alignment, String holidayPrice,
      MainAxisAlignment alighment,
      {Color color = Colors.transparent, double leftPadding = 0}) {
    return Container(
      alignment: alignment,
      color: color,
      padding: EdgeInsets.only(left: leftPadding, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: alighment,
        children: [
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            holidayPrice,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _info() {
    return Expanded(
      child: SingleChildScrollView(
          child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            const Text(
              "1.Инвентарь выдается только при наличии паспорта или водительского удостоверения (один комплект – на один документ или денежный залог в размере 10 000 р.)\n"
              "2.После 20:00 инвентарь не выдается\n"
              "3.Работник проката вправе отказать в выдаче инвентаря без объяснения причин.\n"
              "Подробный прайс и другая полезная информация -  в нашей группе,\n",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
            GestureDetector(
                onTap: () {
                  launchURL("https://vk.com/akademgora");
                },
                child: Row(
                  children: const [
                     Text(
                      "https://vk.com/akademgora\n",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                )),
            const Text(
              "Уважаемые гости. В нашем комплексе вы можете приобрести подарочные сертификаты на любую сумму и услуги комплекса. А также, есть возможность приобрести депозитный сертификат на любую сумму с возможностью частичного (не разового) использования на протяжении всего сезона.\n"
              "Сертификаты не обналичиваются. На оплату услуг парковки и буфета не распространяются.",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ])),
    );
  }

  void _openMainScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (c) => const MainScreen()),
        (route) => false);
  }
}
