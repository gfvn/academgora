import 'dart:io';

import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/screens/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewsAddScreen extends StatefulWidget {
  const NewsAddScreen({Key? key}) : super(key: key);

  @override
  _NewsAddScreenState createState() => _NewsAddScreenState();
}

class _NewsAddScreenState extends State<NewsAddScreen> {
  final picker = ImagePicker();

  bool _uploadingPhotoToDatabase = false;
  String photoUrl = '';
  File image = File("");
  List<String> numberList = ["1", "2", "3", "4"];
  String choosedNumber = "1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: Padding(
          padding:
              const EdgeInsets.only(bottom: 30, top: 70, right: 16, left: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildRoleText("Добавить новости"),
                const SizedBox(
                  height: 16,
                ),
                _newsPhoto(),
                const SizedBox(
                  height: 16,
                ),
                _redactPhotoButton(context),
                const SizedBox(
                  height: 48,
                ),
                buildRoleText("Выберите число"),
                const SizedBox(
                  height: 16,
                ),
                buildDroppButton(),
                 const SizedBox(
                  height: 16,
                ),
                buildInstructionText()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _redactPhotoButton(BuildContext context) {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.05,
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: () {
              _selectOption(context);
            },
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Добавить фото",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            )),
      ),
    );
  }

  void _selectOption(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Выбрать из галереи'),
            onPressed: () {
              _makePhoto(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Сделать фото'),
            onPressed: () {
              _makePhoto(ImageSource.camera);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _makePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    File photo = File(pickedFile!.path);
    setState(() {
      image = photo;
      _uploadingPhotoToDatabase = true;
    });
    // _updateDatabase(photo);
  }

  Widget buildRoleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
    Widget buildInstructionText() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "*Это число озночает позицию карртинки в главном экране приложения ", textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _newsPhoto() {
    if (_uploadingPhotoToDatabase) {
      return SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.2,
          child: Image.file(image));
    } else {
      return SizedBox(
          width: screenWidth * 0.7,
          height: screenHeight * 0.2,
          child:
              const Image(image: AssetImage('assets/all_instructors/123.png')));
    }
  }

  Widget buildDroppButton() {
    return Container(
      decoration: BoxDecoration(
              color: Colors.white,

        borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: DropdownButton(
          hint: const Text("Выберите число"),
          dropdownColor: Colors.white,
          value: choosedNumber,
          focusColor: Colors.white,
          onChanged: (value) {
            setState(() {
              choosedNumber = value.toString();
            });
          },
          items: numberList.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
        ),
      ),
    );
  }
}
