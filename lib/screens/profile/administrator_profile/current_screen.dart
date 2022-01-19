import 'package:flutter/material.dart';

class CurrentScreen extends StatefulWidget {
  const CurrentScreen({ Key? key }) : super(key: key);

  @override
  _CurrentScreenState createState() => _CurrentScreenState();
}

class _CurrentScreenState extends State<CurrentScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("В разработке"),
      ),
    );
  }
}