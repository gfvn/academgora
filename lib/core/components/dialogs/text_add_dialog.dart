import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/dialogs/main_dialog.dart';
import 'package:academ_gora_release/core/components/inputs/main_input.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:academ_gora_release/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TextAddDialog extends StatelessWidget {
  final String title;
  final String text;
  final Function onAcept;
  final TextEditingController textController;
  // ignore: use_key_in_widget_constructors
  const TextAddDialog(
      {required this.title,
      required this.text,
      required this.onAcept,
      required this.textController});
  Widget buildText() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30, bottom: 30),
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
        Navigator.pop(context,textController.text );
        onAcept();
      },
      tittle: "Добавить",
      width: width * 0.3,
      fontSize: 14,
      height: 40,
    );
  }

  Widget buildTextInput() {
    return MainTextField(
      width: screenWidth * 0.7,
      textInputType: TextInputType.text,
      controller: textController,
      height: 80,
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

  @override
  Widget build(BuildContext context) {
    return MainDialog(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildText(),
          buildTextInput(),
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
