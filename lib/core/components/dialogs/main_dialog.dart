import 'package:academ_gora_release/core/components/cards/main_card.dart';
import 'package:academ_gora_release/core/style/color.dart';
import 'package:flutter/material.dart';

class MainDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;

  // ignore: use_key_in_widget_constructors
  const MainDialog(
      {required this.title,
      required this.child,
      this.margin = EdgeInsets.zero,
      this.padding = const EdgeInsets.only(left: 24, right: 24)});

  Widget buildTitle() {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: MainCard(
          padding: const EdgeInsets.only(bottom: 30),
          borderRadius: BorderRadius.circular(10),
          color: kWhite,
          margin: const EdgeInsets.only(bottom: 30),
          shadowPadding: const EdgeInsets.only(bottom: 30),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildTitle(),
                Container(padding: padding, child: child)
              ]),
        ),
      ),
    );
  }
}
