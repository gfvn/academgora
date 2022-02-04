import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/dialogs/main_dialog.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CancelDialog extends StatelessWidget {
  final String title;
  final String text;
  final Function onAcept;

  // ignore: use_key_in_widget_constructors
  const CancelDialog(
      {required this.title, required this.text, required this.onAcept});
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
        Navigator.pop(context);
        onAcept();
      },
      tittle: "Выйти",
      width: width * 0.3,
      fontSize: 14,
      height: 40,
    );
  }

  Widget buildButtonCancel(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AcademButton(
      onTap: () => Navigator.pop(context),
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
