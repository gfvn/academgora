import 'package:flutter/material.dart';

Widget horizontalDivider(double left, double right, double top, double bottom) {
  return Container(
    color: Colors.grey.withOpacity(0.5),
    height: 1,
    margin: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
  );
}
