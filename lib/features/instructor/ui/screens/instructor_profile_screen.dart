import 'package:academ_gora_release/features/instructor/domain/enteties/instructor.dart';
import 'package:academ_gora_release/features/instructor/ui/screens/instructor_profile/instructor_photo_widget.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../../../core/consants/extension.dart';

class InstructorProfileScreen extends StatelessWidget {
  final Instructor instructor;

  const InstructorProfileScreen(this.instructor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${instructor.name}"),
        centerTitle: true,
      ),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: screenDecoration("assets/instructor_profile/bg.png"),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.06),
                    child: InstructorPhotoWidget(
                      instructor,
                      width: screenHeight * 0.2,
                      height: screenHeight * 0.2,
                    ),
                  ),
                  _instructorNameWidget(),
                  _instructorInfoWidget(),
                  _instructorPhoneWidget(),
                  _socialNetworksList(),
                  // _backButtons(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _instructorNameWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        instructor.name ?? "",
        style: const TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _instructorInfoWidget() {
    return Container(
      // height: screenHeight * 0.25,
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        instructor.info ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _instructorPhoneWidget() {
    return GestureDetector(
      onTap: () {
        callNumber(instructor.phone!);
      },
      child: GestureDetector(
        onTap: () {
          callNumber(instructor.phone!);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(
              left: screenWidth * 0.1, top: screenHeight * 0.02),
          child: Text(
            "Телефон: ${instructor.phone}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _socialNetworksList() {
    return SizedBox(
      height: screenHeight * 0.3,
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        itemCount: instructor.socialNetworks != null
            ? instructor.socialNetworks!.length
            : 0,
        itemBuilder: (context, index) {
          return "${instructor.socialNetworks!.values.toList()[index]}"
                  .isNotEmpty
              ? _socialNetworkWidget(
                  _getSocialNetworkImagePath(
                      "${instructor.socialNetworks!.keys.toList()[index]}"),
                  "${instructor.socialNetworks!.values.toList()[index]}")
              : Container();
        },
      ),
    );
  }

  Widget _socialNetworkWidget(String path, String url) {
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
          GestureDetector(
            onTap: () {
              if (path ==
                      "assets/instructor_profile/social_network_icons/9telegram.png" &&
                  !url.contains("https://t.me/")) {
                launchURL("https://t.me/" + url.replaceAll("@", ""));
              }
              launchURL(url);
            },
            child: SizedBox(
              width: screenWidth * 0.7,
              child: Text(
                url,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSocialNetworkImagePath(String socialNetworkName) {
    switch (socialNetworkName) {
      case "instagram":
        return "assets/instructor_profile/social_network_icons/2insta.png";
      case "vk":
        return "assets/instructor_profile/social_network_icons/3vk.png";
      case "facebook":
        return "assets/instructor_profile/social_network_icons/4fb.png";
      case "ok":
        return "assets/instructor_profile/social_network_icons/5ok.png";
      case "twitter":
        return "assets/instructor_profile/social_network_icons/6twitter.png";
      case "tiktok":
        return "assets/instructor_profile/social_network_icons/7tiktok.png";
      case "youtube":
        return "assets/instructor_profile/social_network_icons/8youtube.png";
      case "telegram":
        return "assets/instructor_profile/social_network_icons/9telegram.png";
      default:
        return "";
    }
  }
}
