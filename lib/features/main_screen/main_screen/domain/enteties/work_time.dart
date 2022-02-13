
class WorkTime {
  List<dynamic>? photo = [];
  Map<String, dynamic>? rest_text;

  WorkTime({required this.photo,this.rest_text});

  WorkTime.fromJson(Map json) {

    rest_text = Map<String, dynamic>.from(json['обзац']);
    if (json['Фото'] != null) {
      json['Фото'].forEach((element){
        photo?.add(element);
      });
    }

  }
}

class WorkText {
  String? id;
  String? text;
  bool? isLink;


  WorkText({this.id, this.text, this.isLink});

  WorkText.fromJson(String idS, Map json) {
    id = idS;
    text = json['обзац'];
    isLink = json['isLink'];
  }
}

class WorkZone {
  String? id;
  String? photo;

  WorkZone.fromJson(Map json){
    id = json['Место'];
    photo = json['Фото'];
  }
}
