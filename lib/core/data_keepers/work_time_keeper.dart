import 'package:academ_gora_release/core/api/firebase_requests_controller.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/chill_zone.dart';
import 'package:academ_gora_release/features/main_screen/main_screen/domain/enteties/work_time.dart';


class WorkTimeKeeper {
  static final WorkTimeKeeper _workTimeKeeper = WorkTimeKeeper._();

  WorkTimeKeeper._();

  factory WorkTimeKeeper() {
    return _workTimeKeeper;
  }

  WorkTime? workTime;
  List<WorkText> listWork = [];
  List<String> workUrl = [];
  List<dynamic> work = [];
  final FirebaseRequestsController _firebaseRequestsController =
      FirebaseRequestsController();

  void updateInstructors(Map instructors) {
    listWork = [];
    work = [];
    workTime = WorkTime.fromJson(instructors);
    workTime?.rest_text?.forEach((key, value) {
      listWork.add(WorkText.fromJson(key, value));
    });
    workTime?.photo?.forEach((element) {
      work.add(element);
    });
    updateNewsUrls();
  }

  void updateNewsUrls() async {
    workUrl = [];
    work.forEach((element)async{
      if (element != null)
        {
          final String url = await saveImageUrl(imageName: element['Фото'].toString());
          workUrl.add(url);
        }
    });
  }

  Future<String> saveImageUrl({required String imageName}) async {
    String url = "";
    if (imageName == "") {
      return url;
    }
    await _firebaseRequestsController
        .getDownloadUrlFromFirebaseStorage("work_time/$imageName")
        .then(
      (downloadUrl) {
        url = downloadUrl.toString();
      },
    );
    return url;
  }
}
