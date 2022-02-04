import 'package:academ_gora_release/core/components/buttons/main_button.dart';
import 'package:academ_gora_release/core/components/dialogs/main_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String text;

  // ignore: use_key_in_widget_constructors
  const MessageDialog({required this.title, required this.text});
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
    return Container(
      width: width,
      alignment: Alignment.center,
      child: MainButton(
        title: 'Вернуться назад',
        height: 40,
        width: width * 0.3,
        fontSize: 14,
        onPressed: () => Navigator.pop(context),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainDialog(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[buildText(), buildButton(context)],
      ),
    );
  }
}
