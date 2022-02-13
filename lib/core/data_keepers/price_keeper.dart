

import 'package:academ_gora_release/features/administrator/domain/enteties/price_setting_model.dart';

class PriceKeeper {
  static final PriceKeeper _userDataKeeper = PriceKeeper._internal();
  List<String> priceList = [];
  PriceModel? _priceModel;
  List<ParagraphText> listParagraph = [];
  List<PriceNumber> listKeyPrice = [];




  PriceKeeper._internal();
  factory PriceKeeper() {
    return _userDataKeeper;
  }

  void updateWorkouts(List<String> priceList) {
    this.priceList = priceList;
  }

  List<String> get priceListOfString => priceList;

  void updateInstructors(Map instructors) {
    listParagraph = [];
    listKeyPrice = [];
    _priceModel = PriceModel.fromJson(instructors);
    _priceModel?.paragraphText?.forEach((key, value) {
      listParagraph.add(ParagraphText.fromJson(key, value));
    });
    _priceModel?.price?.forEach((key, value) {
      listKeyPrice.add(PriceNumber.fromJson(key, value));
    });
  }


}
