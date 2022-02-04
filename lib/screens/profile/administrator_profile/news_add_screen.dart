import 'dart:io';

import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/data_keepers/news_keeper.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:academ_gora_release/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: screenDecoration("assets/all_instructors/bg.png"),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 70, right: 16, left: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      _saveButton(context),
                      _saveDeleteButton(context),
                      _backToMainScreenButton(context),
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
                  "Выбрать фото",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.07,
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
          onTap: () {
            _updateDatabase(image, choosedNumber);
          },
          child: !isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Опубликовать",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _saveDeleteButton(BuildContext context) {
    return Container(
      width: screenWidth * 0.8,
      height: screenHeight * 0.07,
      margin: const EdgeInsets.only(top: 10),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.red,
        child: InkWell(
          onTap: () {
            _deleteNews(choosedNumber);
          },
          child: !isDeleteLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Удалить",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
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

  Widget buildRoleText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _backToMainScreenButton(BuildContext context) {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.06,
      margin: const EdgeInsets.only(top: 18),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
          onTap: () => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (c) => const MainScreen()),
                (route) => false)
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "НА ГЛАВНУЮ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
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
