import 'dart:io';

import 'package:academ_gora_release/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/data_keepers/instructors_keeper.dart';
import 'package:academ_gora_release/model/instructor.dart';
import 'package:academ_gora_release/model/user_role.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

import '../../../main.dart';
import '../../extension.dart';
import 'instructor_photo_widget.dart';
import 'instructor_workouts_screen.dart';

class InstructorProfileScreen extends StatefulWidget {
  final String? instructorPhoneNumber;

  const InstructorProfileScreen({Key? key, this.instructorPhoneNumber})
      : super(key: key);

  @override
  _InstructorProfileScreenState createState() =>
      _InstructorProfileScreenState();
}

class _InstructorProfileScreenState extends State<InstructorProfileScreen> {
  Instructor _currentInstructor = Instructor();
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();
  final InstructorsKeeper _instructorsKeeper = InstructorsKeeper();
  final picker = ImagePicker();
  bool _uploadingPhotoToDatabase = false;

  @override
  void initState() {
    super.initState();
    _instructorsKeeper.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    _getInstructorInfo();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.only(top: 50, bottom: 50),
          width: screenWidth,
          height: screenHeight,
          decoration: screenDecoration("assets/instructor_profile/bg.png"),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _instructorPhoto(),
                    _redactPhotoButton(context),
                    _instructorName(),
                    _instructorInfo(),
                    _redactInstructorInfoButton(context),
                    _socialNetworksList(context),
                  ],
                ),
                _backButton(context)
              ],
            ),
          ),
        ));
  }

  Widget _instructorPhoto() {
    if (_uploadingPhotoToDatabase) {
      return const SizedBox(
          width: 30, height: 30, child: CircularProgressIndicator());
    } else {
      return InstructorPhotoWidget(_currentInstructor);
    }
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
                      "РЕДАКТИРОВАТЬ ФОТО",
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
    _updateDatabase(photo);
  }

  void _updateDatabase(File photo) async {
    setState(() {
      _uploadingPhotoToDatabase = true;
    });
    String fileName = basename(photo.path);
    _firebaseRequestsController
        .uploadFileToFirebaseStorage('instructors_photos/$fileName', photo)
        .then((value) {
      _firebaseRequestsController.update(
          "${UserRole.instructor}/${_currentInstructor.id}",
          {"Фото": fileName}).then((value) {
        setState(() {
          _uploadingPhotoToDatabase = false;
        });
      });
    });
  }

  Widget _instructorName() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        _currentInstructor.name == null ? "" : _currentInstructor.name!,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _instructorInfo() {
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        // height: screenHeight * 0.18,
        width: screenWidth * 0.8,
        child: SingleChildScrollView(
            child: Flex(
          direction: Axis.vertical,
          children: [
            Text(
              _currentInstructor.info == null ? "" : _currentInstructor.info!,
              style: TextStyle(fontSize: 14),
            )
          ],
        )));
  }

  Widget _redactInstructorInfoButton(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          _showRedactInfoDialog(context, _currentInstructor.info ?? "", false),
      child: const Text(
        "Редактировать информацию о себе",
        style: TextStyle(color: Colors.blue),
      ),
    );
  }

  void _showRedactInfoDialog(
      BuildContext context, String text, bool isSocialNetwork,
      {String? socialNetworkName}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _redactInfoDialogContent(context, text, isSocialNetwork,
              socialNetworkName: socialNetworkName),
        );
      },
    );
  }

  Widget _redactInfoDialogContent(
      BuildContext context, String text, bool isSocialNetwork,
      {String? socialNetworkName}) {
    TextEditingController myController = TextEditingController(text: text);
    return SizedBox(
      height: screenHeight * 0.19,
      child: Column(
        children: [
          TextField(
            controller: myController,
          ),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: OutlinedButton(
                      child: const Text('ОК'),
                      onPressed: () {
                        _updateInstructorInfo(
                            myController.value.text, isSocialNetwork,
                            socialNetworkName: socialNetworkName);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  OutlinedButton(
                    child: const Text('ОТМЕНА'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }

  void _updateInstructorInfo(String updatedText, bool isSocialNetwork,
      {String? socialNetworkName}) async {
    String userId = "";
    if (widget.instructorPhoneNumber != null) {
      userId = _instructorsKeeper
          .findInstructorByPhoneNumber(widget.instructorPhoneNumber!)!
          .id!;
    } else {
      userId = FirebaseAuth.instance.currentUser!.uid;
    }
    Map<String, dynamic> info = {};
    String path = "";
    if (isSocialNetwork) {
      path = "${UserRole.instructor}/$userId/Соцсети";
      info = {socialNetworkName!: updatedText};
    } else {
      path = "${UserRole.instructor}/$userId";
      info = {"Информация": updatedText};
    }
    await _firebaseRequestsController.update(path, info);
  }

  Widget _socialNetworksList(BuildContext context) {
    var socialNetworksMap = {};
    if (_currentInstructor.socialNetworks != null &&
        _currentInstructor.socialNetworks!.isNotEmpty) {
      socialNetworksMap = _currentInstructor.socialNetworks!;
    }
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/1phone.png",
              text: widget.instructorPhoneNumber != null
                  ? widget.instructorPhoneNumber!
                  : FirebaseAuth.instance.currentUser!.phoneNumber!),
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/2insta.png",
              text: socialNetworksMap["instagram"],
              socialNetworkName: "instagram"),
          _socialNetworkWidget(
              context, "assets/instructor_profile/social_network_icons/3vk.png",
              text: socialNetworksMap["vk"], socialNetworkName: "vk"),
          _socialNetworkWidget(
              context, "assets/instructor_profile/social_network_icons/4fb.png",
              text: socialNetworksMap["facebook"],
              socialNetworkName: "facebook"),
          _socialNetworkWidget(
              context, "assets/instructor_profile/social_network_icons/5ok.png",
              text: socialNetworksMap["ok"], socialNetworkName: "ok"),
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/6twitter.png",
              text: socialNetworksMap["twitter"], socialNetworkName: "twitter"),
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/7tiktok.png",
              text: socialNetworksMap["tiktok"], socialNetworkName: "tiktok"),
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/8youtube.png",
              text: socialNetworksMap["youtube"], socialNetworkName: "youtube"),
          _socialNetworkWidget(context,
              "assets/instructor_profile/social_network_icons/9telegram.png",
              text: socialNetworksMap["telegram"],
              socialNetworkName: "telegram"),
        ],
      ),
    );
  }

  Widget _socialNetworkWidget(BuildContext context, String path,
      {String? text, String? socialNetworkName}) {
    return Container(
      margin: const EdgeInsets.only(top: 3, bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            height: 22,
            width: 22,
            child: Image.asset(path),
          ),
          SizedBox(
            width: screenWidth * 0.6,
            child: Text(
              text ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          (text != FirebaseAuth.instance.currentUser!.phoneNumber &&
                  (text != widget.instructorPhoneNumber || text == null))
              ? GestureDetector(
                  onTap: () => _showRedactInfoDialog(context, text ?? "", true,
                      socialNetworkName: socialNetworkName),
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 20,
                    width: 20,
                    child: Image.asset(
                        "assets/instructor_profile/social_network_icons/0edit.png"),
                  ))
              : Container(
                  height: 20,
                  width: 20,
                  margin: const EdgeInsets.only(right: 15)),
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.05,
      margin: const EdgeInsets.only(top: 25),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(35)),
        color: Colors.blue,
        child: InkWell(
            onTap: () {
              _openInstructorWorkoutsScreen(context);
            },
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "НАЗАД",
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

  void _getInstructorInfo() {
    if (widget.instructorPhoneNumber != null) {
      _currentInstructor = _instructorsKeeper
          .findInstructorByPhoneNumber(widget.instructorPhoneNumber!)!;
    } else {
      _currentInstructor = _instructorsKeeper.findInstructorByPhoneNumber(
          FirebaseAuth.instance.currentUser!.phoneNumber!)!;
    }
  }

  void _openInstructorWorkoutsScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => InstructorWorkoutsScreen(
            instructorPhoneNumber: widget.instructorPhoneNumber,
          ),
        ),
        (route) => false);
  }

  @override
  void dispose() {
    super.dispose();
    _instructorsKeeper.removeListener(this);
  }
}
