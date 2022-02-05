import 'dart:io';

import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/data_keepers/news_keeper.dart';
import 'package:academ_gora_release/core/functions/functions.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:academ_gora_release/core/style/color.dart';

class NewsAddScreen extends StatefulWidget {
  const NewsAddScreen({Key? key}) : super(key: key);

  @override
  _NewsAddScreenState createState() => _NewsAddScreenState();
}

class _NewsAddScreenState extends State<NewsAddScreen> {
  final picker = ImagePicker();
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  final NewsKeeper _newsDataKeeper = NewsKeeper();
  bool _uploadingPhotoToDatabase = false;
  bool isLoading = false;
  bool isDeleteLoading = false;
  bool isChaged = false;
  String photoUrl = '';
  File image = File("");
  List<String> numberList = ["1", "2", "3", "4"];
  String choosedNumber = "1";

  //functions

  void _makePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.pickImage(source: imageSource);
    File photo = File(pickedFile!.path);
    setState(
      () {
        image = photo;
        _uploadingPhotoToDatabase = true;
      },
    );
    // _updateDatabase(photo);
  }

  void _updateDatabase(File photo, String id) async {
    setState(
      () {
        isLoading = true;
      },
    );
    String fileName = basename(photo.path);
    _firebaseRequestsController
        .uploadFileToFirebaseStorage('news_photos/$fileName', photo)
        .then(
      (value) {
        _firebaseRequestsController
            .update("Новости/$id", {"Фото": fileName, "Место": id}).then(
          (value) async {
            await _firebaseRequestsController.getAsList('Новости').then(
              (value) {
                _newsDataKeeper.updateInstructors(value);
              },
            );
            setState(
              () {
                isLoading = false;
              },
            );
          },
        );
      },
    );
  }

  void _deleteNews(String id) async {
    setState(
      () {
        isDeleteLoading = true;
      },
    );

    await _firebaseRequestsController
        .update("Новости/$id", {"Фото": "", "Место": id}).then(
      (value) async {
        await Future.delayed(const Duration(milliseconds: 1000));
        await _firebaseRequestsController.getAsList('Новости').then(
          (value) {
            _newsDataKeeper.updateInstructors(value);
          },
        );
        setState(
          () {
            isDeleteLoading = false;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Добавить новости",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 20, right: 16, left: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      // buildRoleText("Добавить новости"),
                      const SizedBox(
                        height: 16,
                      ),
                      _newsPhoto(),
                      const SizedBox(
                        height: 16,
                      ),
                      AcademButton(
                          onTap: () {
                            _selectOption(context);
                          },
                          tittle: "выбрать фото",
                          width: screenWidth * 0.6,
                          fontSize: 18),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      buildRoleText("Выберите число"),
                      const SizedBox(
                        height: 16,
                      ),
                      buildDroppButton(),
                      const SizedBox(
                        height: 16,
                      ),
                      buildInstructionText(),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           AcademButton(
                        onTap: () {
                          _updateDatabase(image, choosedNumber);
                        },
                        tittle: "Сохранить",
                        width: screenWidth * 0.4,
                        fontSize: 18,
                      ),
                      const SizedBox(width: 10,),
                      AcademButton(
                        onTap: () {
                          _deleteNews(choosedNumber);
                        },
                        tittle: "Удалить",
                        width: screenWidth * 0.4,
                        fontSize: 18,
                        colorButton: kRed,
                      ),
                        ],
                      ),

                     
                      AcademButton(
                        onTap: () {
                          FunctionsConsts.openMainScreen(context);
                        },
                        tittle: "На главную",
                        width: screenWidth * 0.6,
                        fontSize: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
        "Данное число обозначает позицию новости на главном экране приложения.",
        textAlign: TextAlign.center,
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
        child: const Image(
          image: AssetImage('assets/all_instructors/123.png'),
        ),
      );
    }
  }

  Widget buildDroppButton() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
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
