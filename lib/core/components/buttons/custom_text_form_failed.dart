import 'package:flutter/material.dart';

class CustomTextFormFailed extends StatelessWidget {
  const CustomTextFormFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
        ),
        child: TextFormField(
          decoration: const InputDecoration(
            labelStyle: TextStyle(
                color: Colors.white,),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
