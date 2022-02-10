
class RestZone {
  List<NewsZone> photo = [];
  Map<String, dynamic>? rest_text;

  RestZone({required this.photo,this.rest_text});

  RestZone.fromJson(Map json) {

    rest_text = Map<String, dynamic>.from(json['обзац']);
    print(json);


  }
}

class RestText {
  String? id;
  String? text;
  bool? isLink;

  RestText({this.id, this.text, this.isLink});

  RestText.fromJson(String idS, Map json) {
    id = idS;
    text = json['обзац'];
    isLink = json['isLink'];
  }
}

class NewsZone {
  String? id;
  String? photo;

  NewsZone.fromJson(Map json){
    id = json['Место'];
    photo = json['Фото'];
  }
}
