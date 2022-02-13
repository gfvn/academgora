import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/about_us.dart';


class AboutUsKeeper {
  static final AboutUsKeeper _cancelKeeper = AboutUsKeeper._();

  AboutUsKeeper._();

  factory AboutUsKeeper() {
    return _cancelKeeper;
  }

  AboutUs? aboutUs;
  List<AboutUsText> listAboutUs = [];
  List<String> aboutUsUrl = [];
  List<dynamic> about = [];
  final FirebaseRequestsController _firebaseRequestsController =
  FirebaseRequestsController();

  void updateInstructors(Map instructors) {
    listAboutUs = [];
    about = [];
    aboutUs = AboutUs.fromJson(instructors);
    aboutUs?.rest_text?.forEach((key, value) {
      listAboutUs.add(AboutUsText.fromJson(key, value));
    });
    aboutUs?.photo?.forEach((element) {
      about.add(element);
    });
    updateNewsUrls();
  }

  void updateNewsUrls() async {
    aboutUsUrl = [];
    about.forEach((element)async{
      if (element != null)
      {
        final String url = await saveImageUrl(imageName: element['Фото'].toString());
        aboutUsUrl.add(url);
      }
    });
  }

  Future<String> saveImageUrl({required String imageName}) async {
    String url = "";
    if (imageName == "") {
      return url;
    }
    await _firebaseRequestsController
        .getDownloadUrlFromFirebaseStorage("about_us/$imageName")
        .then(
          (downloadUrl) {
        url = downloadUrl.toString();
      },
    );
    return url;
  }
}
