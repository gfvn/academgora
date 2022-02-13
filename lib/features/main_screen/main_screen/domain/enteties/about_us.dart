
class AboutUs {
  List<dynamic>? photo = [];
  Map<String, dynamic>? rest_text;

  AboutUs({required this.photo,this.rest_text});

  AboutUs.fromJson(Map json) {
    rest_text = Map<String, dynamic>.from(json['обзац']);
    if (json['Фото'] != null) {
      json['Фото'].forEach((element){
        photo?.add(element);
      });
    }

  }
}

class AboutUsText {
  String? id;
  String? text;
  bool? isLink;


  AboutUsText({this.id, this.text, this.isLink});

  AboutUsText.fromJson(String idS, Map json) {
    id = idS;
    text = json['обзац'];
    isLink = json['isLink'];
  }
}

class NewsAboutUs {
  String? id;
  String? photo;

  NewsAboutUs.fromJson(Map json){
    id = json['Место'];
    photo = json['Фото'];
  }
}
