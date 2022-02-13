import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/dialogs/main_dialog.dart';
import 'package:academ_gora_release/core/components/inputs/main_input.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PriceDialog extends StatelessWidget {
  final String title;
  final String text;
  final Function onAcept;
  final TextEditingController nameController;
  final TextEditingController price1Controller;
  final TextEditingController price2Controller;
  final TextEditingController price3Controller;
  final TextEditingController price4Controller;
  // ignore: use_key_in_widget_constructors
  const PriceDialog(
      {required this.title,
        required this.text,
        required this.onAcept,
        required this.price1Controller,
        required this.price2Controller,
        required this.price3Controller,
        required this.price4Controller,
        required this.nameController,
      });
  Widget buildText() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AcademButton(
      onTap: () {
        Navigator.pop(context);
        onAcept();
      },
      tittle: "Добавить",
      width: width * 0.3,
      fontSize: 14,
      height: 40,
    );
  }

  Widget buildTextInput(double width,double height,TextEditingController controller) {
    return MainTextField(
      width: screenWidth * width,
      textInputType: TextInputType.text,
      controller: controller,
      height: height,
    );
  }

  Widget buildButtonCancel(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AcademButton(
      onTap: () => Navigator.pop(context, ""),
      tittle: "Отмена",
      width: width * 0.3,
      fontSize: 14,
      height: 40,
      colorButton: kWhite,
      borderColor: kMainColor,
      colorText: kBlack,
    );
  }

  Widget buildTexts(String text) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainDialog(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildText(),
          buildTextInput(0.7,45, nameController),
          buildTexts("Будни"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  buildTexts("1-й час"),
                  buildTextInput(0.37,45,price1Controller),
                ],
              ),
              Column(
                children: [
                  buildTexts("Целый день"),
                  buildTextInput(0.37,45,price2Controller),
                ],
              ),
            ],
          ),
          buildTexts("Выходные и праздничные дни"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  buildTextInput(0.37,45,price3Controller),
                ],
              ),
              Column(
                children: [
                  buildTextInput(0.37,45,price4Controller),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildButton(context),
              const SizedBox(
                width: 10,
              ),
              buildButtonCancel(context),
            ],
          ),
        ],
      ),
    );
  }
}
