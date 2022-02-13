
class PriceModel {
  Map<String, dynamic>? price;
  Map<String, dynamic>? paragraphText;

  PriceModel({this.price,this.paragraphText});

  PriceModel.fromJson(Map json) {
    paragraphText = json['обзац'] != null ? Map<String, dynamic>.from(json['обзац']) : null;
    price = json['table'] != null ? Map<String, dynamic>.from(json['table']) : null;
  }
}

class PriceNumber {
  PriceNumber({
    required this.key,
    required this.price3,
    required this.price4,
    required this.price1,
    required this.price2,
  });
  late final String key;
  late final String price3;
  late final String price4;
  late final String price1;
  late final String price2;

  PriceNumber.fromJson(String keys,Map json){
    key = keys;
    price3 = json['price3'];
    price4 = json['price4'];
    price1 = json['price1'];
    price2 = json['price2'];
  }


}

class ParagraphText {
  String? id;
  String? text;
  bool? isLink;


  ParagraphText({this.id, this.text, this.isLink});

  ParagraphText.fromJson(String idS, Map json) {
    id = idS;
    text = json['обзац'];
    isLink = json['isLink'];
  }
}

class Paragraph{
  String? id;
  String? photo;

  Paragraph.fromJson(Map json){
    id = json['Место'];
    photo = json['Фото'];
  }
}
