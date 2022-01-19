import 'package:flutter/material.dart';

class CancelsScreen extends StatefulWidget {
  const CancelsScreen({ Key? key }) : super(key: key);

  @override
  _CancelsScreenState createState() => _CancelsScreenState();
}

class _CancelsScreenState extends State<CancelsScreen> {
  @override
 Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("CancelsScreen screen"),
      ),
    );
  }
}