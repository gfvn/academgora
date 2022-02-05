import 'package:flutter/material.dart';

class DropButton extends StatelessWidget {
  const DropButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: DropdownButton(
          hint: const Text("Выберите число"),
          dropdownColor: Colors.white,
          value: choosedNumber,
          focusColor: Colors.white,
          onChanged: (value) {
            setState(
              () {
                choosedNumber = value.toString();
              },
            );
          },
          items: numberList.map(
            (e) {
              return DropdownMenuItem(value: e, child: Text(e));
            },
          ).toList(),
        ),
      ),
    );
  }
}