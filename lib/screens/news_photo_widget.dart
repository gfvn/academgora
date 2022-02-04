
import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/main_screen/domain/enteties/news.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class NewsPhotoImage extends StatefulWidget {
  final News currentPhoto;
  final double? height;
  final double? width;

  const NewsPhotoImage(this.currentPhoto, {Key? key, this.width, this.height})
      : super(key: key);

  @override
  _NewsPhotoImageState createState() => _NewsPhotoImageState();
}

class _NewsPhotoImageState extends State<NewsPhotoImage> {
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _instructorPhoto(),
    );
  }

  Widget _photoWidget(ImageProvider<Object> imageProvider) {
    double? height = widget.height ?? screenWidth * 0.3;
    double? width = widget.width ?? screenWidth * 0.7;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _instructorPhoto() {
    if (widget.currentPhoto.photo != null &&
        widget.currentPhoto.photo!.isNotEmpty) {
      return _photoFromDb();
    } else {
      return _photoWidget(const AssetImage("assets/instructors_list/e_3.png"));
    }
  }

  Widget _photoFromDb() {
    return FutureBuilder(
      future: _getPhotoFromDb(widget.currentPhoto.photo!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.hasData
              ? _photoWidget(snapshot.data as ImageProvider)
              : _photoWidget(
                  const AssetImage("assets/instructors_list/e_3.png"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator()),
          );
        }
        return _photoWidget(
            const AssetImage("assets/instructors_list/e_3.png"));
      },
    );
  }

  Future<NetworkImage> _getPhotoFromDb(String imageName) async {
    NetworkImage? imageFromDb;
    await _firebaseRequestsController
        .getDownloadUrlFromFirebaseStorage("news_photos/$imageName")
        .then((downloadUrl) {
      imageFromDb = NetworkImage(
        downloadUrl.toString(),
      );
    });
    return imageFromDb!;
  }
}
