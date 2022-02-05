import 'package:academ_gora_release/core/components/buttons/custom_text_form_failed.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/ui/screens/main_screen/main_screen.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/rendering.dart';

class PriceSetting extends StatefulWidget {
  const PriceSetting({Key? key}) : super(key: key);

  @override
  _PriceSettingState createState() => _PriceSettingState();
}

class _PriceSettingState extends State<PriceSetting> {
  int counterNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Настройка прайс",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: screenDecoration("assets/all_instructors/bg.png"),
          child: Container(
            margin:
                const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 0),
            child: Flex(
              direction: Axis.vertical,
              children: [
                _priceTitle(),
                _pricePriceInfo(),
                _table(),
                _customButtonAdd(),
                _backToMainScreenButton(),
              ],
            ),
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

  Widget _table() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  _customText('Наименование услуги'),
                  SizedBox(
                    width: 70,
                  ),
                  _customText('1-й час'),
                  SizedBox(
                    width: 50,
                  ),
                  _customText('Целый день'),
                ],
              ),
            ),
          ),
          Table(
            border: TableBorder.all(color: Colors.white, width: 2),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(
              counterNumber,
              (index) => TableRow(children: <Widget>[
                const CustomTextFormFailed(),
                Table(
                  children: const [
                    TableRow(
                      children: <Widget>[
                        CustomTextFormFailed(),
                        CustomTextFormFailed(),
                      ],
                    )
                  ],
                ),
                Table(
                  children: const [
                    TableRow(
                      children: <Widget>[
                        CustomTextFormFailed(),
                        CustomTextFormFailed(),
                      ],
                    )
                  ],
                ),
              ]),
            ),
          ),
        ],
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

  Widget _customText(String text) => Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 13.5,
        ),
      );

  Widget _backToMainScreenButton() {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: kMainColor,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => const MainScreen()),
                (route) => false);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "НА ГЛАВНУЮ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customButtonAdd() {
    return Container(
      height: screenHeight * 0.06,
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: kMainColor,
        child: InkWell(
          onTap: () {
            setState(() {
              counterNumber++;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Добавить",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
