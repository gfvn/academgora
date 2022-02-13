

import 'dart:io';

import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/core/components/buttons/academ_button.dart';
import 'package:academ_gora_release/core/components/dialogs/dialogs.dart';
import 'package:academ_gora_release/core/components/dialogs/text_add_dialog.dart';
import 'package:academ_gora_release/core/consants/constants.dart';
import 'package:academ_gora_release/core/data_keepers/about_us_keeper.dart';
import 'package:academ_gora_release/core/data_keepers/chill_zone_keeper.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/news.dart';
import 'package:academ_gora_release/main.dart';
import 'package:academ_gora_release/core/consants/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:academ_gora_release/core/style/color.dart';

class AboutUsSettings extends StatefulWidget {
  const AboutUsSettings({Key? key}) : super(key: key);

  @override
  _AboutUsSettings createState() => _AboutUsSettings();
}

class _AboutUsSettings extends State<AboutUsSettings> {
  final picker = ImagePicker();
  final FirebaseRequestsController _firebaseRequestsController =
  FirebaseRequestsController();
  final AboutUsKeeper _aboutUsKeeper = AboutUsKeeper();
  bool _uploadingPhotoToDatabase = false;
  bool isLoading = false;
  bool isDeleteLoading = false;
  bool isChaged = false;
  String photoUrl = '';
  File image = File("");
  List<String> numberList = ["1", "2", "3", "4"];
  String choosedNumber = "1";
  List<String> listofStrings = ["Здесь Будут список обзацов и ссылок"];
  TextEditingController linkController = TextEditingController();
  TextEditingController textConytroller = TextEditingController();

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
        .uploadFileToFirebaseStorage('about_us/$fileName', photo)
        .then(
          (value) async {
        _firebaseRequestsController
            .update("О нас/Фото/$id", News.toJson(id, fileName))
            .then((value) async {
          await _firebaseRequestsController
              .getAsList("О нас")
              .then((value) {
            _aboutUsKeeper.updateInstructors(value);
            setState(() {});
          });
        });
      },
    );
  }

  void _addRestZone(bool isLink, String id, String text) async {
    setState(
          () {
        isDeleteLoading = true;
      },
    );
    await _firebaseRequestsController.update(
        "О нас/обзац/$id", {"обзац": text, "isLink": isLink}).then(
          (value) async {
        await _firebaseRequestsController
            .getAsList("О нас")
            .then((value) {
          _aboutUsKeeper.updateInstructors(value);
          setState(() {});
        });
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
          "Изменить о нас",
          style: TextStyle(fontSize: 14),
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
                          tittle: "Выбрать фото",
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
                      buildInstructionText(
                        text:
                        "Данное число обозначает позицию новости на главном экране приложения.",
                      ),
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
                            tittle: "Опубликовать",
                            width: screenWidth * 0.4,
                            fontSize: 14,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AcademButton(
                            onTap: () {},
                            tittle: "Удалить фото",
                            width: screenWidth * 0.4,
                            fontSize: 14,
                            colorButton: kRed,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      buildRoleText("Обзаци и ссылка"),
                      buildInstructionText(
                        text:
                        "Чтобы удалить обзац или ссылку, свайпайте влево или вправо нужного текста",
                      ),
                      buildRoleText('Здесь Будут список обзацов и ссылок'),
                      biuilListOfLinks(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AcademButton(
                            onTap: () async {
                              String link = await Dialogs.showUnmodal(
                                context,
                                TextAddDialog(
                                  title: "Обзац",
                                  text: "Введите текст обзаца",
                                  onAcept: () {
                                    _addRestZone(
                                        false,
                                        sorting(),
                                        textConytroller.text);
                                  },
                                  textController: textConytroller,
                                ),
                              );
                              setState(
                                    () {
                                  if (link.isNotEmpty) {
                                    listofStrings.add(link);
                                    textConytroller.text = '';
                                  }
                                },
                              );
                            },
                            tittle: "Добавить обзац",
                            width: screenWidth * 0.4,
                            fontSize: 14,
                            borderColor: kMainColor,
                            colorText: kMainColor,
                            colorButton: Colors.transparent,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          AcademButton(
                            onTap: () async {
                              String link = await Dialogs.showUnmodal(
                                context,
                                TextAddDialog(
                                  title: "Ссылка",
                                  text: "Введите ссылку",
                                  textController: linkController,
                                  onAcept: () {
                                    _addRestZone(
                                        true,
                                        sorting(),
                                        linkController.text);
                                  },
                                ),
                              );
                              setState(
                                    () {
                                  if (link.isNotEmpty) {
                                    listofStrings.add(link);
                                    linkController.text = '';
                                  }
                                },
                              );
                            },
                            tittle: "Добавить ссылку",
                            width: screenWidth * 0.4,
                            fontSize: 14,
                            borderColor: kMainColor,
                            colorText: kMainColor,
                            colorButton: Colors.transparent,
                          ),
                        ],
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

  Widget biuilListOfLinks() {
    _aboutUsKeeper.listAboutUs.sort((a, b) {
      return (b.id?.toLowerCase().compareTo((a.id?.toLowerCase())!))!;
    });
    return Column(
      children: List.generate(
        _aboutUsKeeper.listAboutUs.length,
            (index) {
          return Dismissible(
              key: ValueKey<String>(
                  DateTime.now().microsecondsSinceEpoch.toString()),
              onDismissed: (DismissDirection direction) async {
                if (direction == DismissDirection.startToEnd) {
                  listofStrings.remove(listofStrings[index]);
                } else {
                  listofStrings.remove(listofStrings[index]);
                }
              },
              background: Container(
                color: kRed,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Удалить',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              secondaryBackground: Container(
                color: kRed,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Удалить',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              child: SizedBox(
                  width: screenWidth,
                  child: Column(
                    children: [
                      buildRoleText("${_aboutUsKeeper.listAboutUs[index].text}"),
                    ],
                  )));
        },
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
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildInstructionText({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
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

