import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/dialogs/dialogs.dart';
import 'package:academ_gora_release/core/components/dialogs/price_dialod.dart';
import 'package:academ_gora_release/core/components/dialogs/text_add_dialog.dart';
import 'package:academ_gora_release/core/consants/constants.dart';
import 'package:academ_gora_release/core/data_keepers/price_keeper.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/material.dart';
import 'package:academ_gora_release/core/style/color.dart';

class PriceSetting extends StatefulWidget {
  const PriceSetting({Key? key}) : super(key: key);

  @override
  _PriceSettingState createState() => _PriceSettingState();
}

class _PriceSettingState extends State<PriceSetting> {
  int counterNumber = 0;
  TextEditingController linkController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController price1Controller = TextEditingController();
  TextEditingController price2Controller = TextEditingController();
  TextEditingController price3Controller = TextEditingController();
  TextEditingController price4Controller = TextEditingController();
  List<String> listofStrings = ["Здесь Будут список обзацов и ссылок"];

  final PriceKeeper _priceKeeper = PriceKeeper();

  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

  void setDataFirebase(String name, String price1, String price2, String price3,
      String price4) async {
    await _firebaseRequestsController
        .update("Прайс/table/$name",
        {"price1": price1, "price2": price2, "price3": price3, "price4": price4})
        .then((value) async {
      await _firebaseRequestsController.getAsList("Прайс").then((value) {
        _priceKeeper.updateInstructors(value);
        setState(() {});
      });
    });
  }

  void _addRestZone(bool isLink, String id, String text) async {
    await _firebaseRequestsController.update(
        "Прайс/обзац/$id", {"обзац": text, "isLink": isLink}).then(
          (value)async {
            await _firebaseRequestsController
            .getAsList("Прайс")
            .then((value) {
          _priceKeeper.updateInstructors(value);
          setState(() {});
        });
      },
    );
  }

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
          height: screenHeight,
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
                buildRoleText("Обзаци и ссылка"),
                buildInstructionText(
                  text:
                      "Чтобы удалить обзац или ссылку, свайпайте влево или вправо нужного текста",
                ),
                biuilListOfLinks(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AcademButton(
                      onTap: () async {
                        String link = await Dialogs.showUnmodal(
                          context,
                          TextAddDialog(
                            title: "Обзац",
                            text: "Введите текст обзаца",
                            onAcept: () {
                              _addRestZone(
                                false,
                                sorting(),
                                nameController.text,
                              );
                            },
                            textController: nameController,
                          ),
                        );
                        setState(
                          () {
                            if (link.isNotEmpty) {
                              listofStrings.add(link);
                              nameController.text = '';
                            }
                          },
                        );
                      },
                      tittle: "Добавить обзац",
                      width: screenWidth * 0.4,
                      fontSize: 14,
                      borderColor: kMainColor,
                      colorText: kMainColor,
                      colorButton: Colors.transparent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    AcademButton(
                      onTap: () async {
                        String link = await Dialogs.showUnmodal(
                          context,
                          TextAddDialog(
                            title: "Ссылка",
                            text: "Введите ссылку",
                            textController: linkController,
                            onAcept: () {
                          _addRestZone(
                              true,
                              sorting(),
                              linkController.text,
                          );
                            },
                          ),
                        );
                        setState(
                          () {
                            if (link.isNotEmpty) {
                              listofStrings.add(link);
                              linkController.text = '';
                            }
                          },
                        );
                      },
                      tittle: "Добавить ссылку",
                      width: screenWidth * 0.4,
                      fontSize: 14,
                      borderColor: kMainColor,
                      colorText: kMainColor,
                      colorButton: Colors.transparent,
                    ),
                  ],
                ),
                _backToMainScreenButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget biuilListOfLinks() {
    return Column(
      children: List.generate(
        _priceKeeper.listParagraph.length,
        (index) {
          return Dismissible(
            key: ValueKey<String>(
                DateTime.now().microsecondsSinceEpoch.toString()),
            onDismissed: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                _priceKeeper.listParagraph.remove(_priceKeeper.listParagraph[index]);
              } else {
                _priceKeeper.listParagraph.remove(_priceKeeper.listParagraph[index]);
              }
            },
            background: Container(
              color: kRed,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Удалить',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            secondaryBackground: Container(
              color: kRed,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Удалить',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            child: SizedBox(
              width: screenWidth,
              child: buildRoleText(
                "${_priceKeeper.listParagraph[index].text}",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildInstructionText({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget buildRoleText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
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

  Widget buildTittle() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _customText('Наименование услуги'),
            _customText('1-й час'),
            _customText('Целый день'),
          ],
        ),
      ),
    );
  }

  Widget _table() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          buildTittle(),
          Table(
            border: TableBorder.all(color: Colors.white, width: 2),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(),
              2: FlexColumnWidth(),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(
              _priceKeeper.listKeyPrice.length,
                  (index) => TableRow(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,top: 5.0,bottom: 5.0),
                    child: _customText(_priceKeeper.listKeyPrice[index].key),
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: <Widget>[
                          _customTextTable(
                              _priceKeeper.listKeyPrice[index].price1,
                              _priceKeeper.listKeyPrice[index].price2),
                        ],
                      )
                    ],
                  ),
                  Table(
                    children: [
                      TableRow(
                        children: <Widget>[
                          _customTextTable(
                            _priceKeeper.listKeyPrice[index].price3,
                            _priceKeeper.listKeyPrice[index].price4,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
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

  Widget _customTextTable(String text1, String text2) => Padding(
    padding: const EdgeInsets.only(left: 20.0),
    child: Row(
          children: [
            Text(
              text1,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(width: 5,),
            const Text(
              '/',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(width: 5,),
            Text(
              text2,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
  );

  Widget _backToMainScreenButton() {
    return AcademButton(
      onTap: () {
        setState(() {
          counterNumber++;
        });
      },
      tittle: "Сохранить",
      width: screenWidth * 0.9,
      fontSize: 16,
    );
  }

  Widget _customButtonAdd() {
    return AcademButton(
      onTap: () async {
        await Dialogs.showUnmodal(
          context,
          PriceDialog(
            title: "ПРАЙС",
            text: "Наименование услуги",
            onAcept: () {},
            nameController: nameController,
            price1Controller: price1Controller,
            price2Controller: price2Controller,
            price3Controller: price3Controller,
            price4Controller: price4Controller,
          ),
        );
        setState(() {
          setDataFirebase(
            nameController.text,
            price1Controller.text,
            price2Controller.text,
            price3Controller.text,
            price4Controller.text,
          );
          cleanController();
        });

      },
      tittle: "Добавить",
      width: screenWidth * 0.9,
      fontSize: 16,
      colorButton: Colors.transparent,
      colorText: kMainColor,
      borderColor: kMainColor,
    );
  }

  void cleanController() {
    nameController.clear();
    price1Controller.clear();
    price2Controller.clear();
    price3Controller.clear();
    price4Controller.clear();
  }

}


