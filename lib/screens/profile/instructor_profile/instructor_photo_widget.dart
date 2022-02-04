import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class InstructorPhotoWidget extends StatefulWidget {
  final Instructor currentInstructor;
  final double? height;
  final double? width;

  const InstructorPhotoWidget(this.currentInstructor,
      {Key? key, this.width, this.height})
      : super(key: key);

  @override
  _InstructorPhotoWidgetState createState() => _InstructorPhotoWidgetState();
}

class _InstructorPhotoWidgetState extends State<InstructorPhotoWidget> {
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _instructorPhoto(),
    );
  }

  Widget _photoWidget(ImageProvider<Object> imageProvider) {
    double? height = widget.height ?? screenHeight * 0.14;
    double? width = widget.width ?? screenHeight * 0.14;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
      ),
    );
  }

  Widget _instructorPhoto() {
    if (widget.currentInstructor.photoUrl != null &&
        widget.currentInstructor.photoUrl!.isNotEmpty) {
      return _photoFromDb();
    } else {
      return _photoWidget(const AssetImage("assets/instructors_list/e_3.png"));
    }
  }

  Widget _photoFromDb() {
    return FutureBuilder(
      future: _getPhotoFromDb(widget.currentInstructor.photoUrl!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData
              ? _photoWidget(snapshot.data as ImageProvider)
              : _photoWidget(const AssetImage("assets/instructors_list/e_3.png"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
              width: 30, height: 30, child: CircularProgressIndicator());
        }
        return _photoWidget(const AssetImage("assets/instructors_list/e_3.png"));
      },
    );
  }

  Future<NetworkImage> _getPhotoFromDb(String imageName) async {
    NetworkImage? imageFromDb;
    await _firebaseRequestsController
        .getDownloadUrlFromFirebaseStorage("instructors_photos/$imageName")
        .then((downloadUrl) {
      imageFromDb = NetworkImage(
        downloadUrl.toString(),
      );
    });
    return imageFromDb!;
  }
}
