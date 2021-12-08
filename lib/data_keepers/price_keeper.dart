class PriceKeeper {
  static final PriceKeeper _userDataKeeper = PriceKeeper._internal();
  List<String> priceList = [];

  PriceKeeper._internal();
  factory PriceKeeper() {
    return _userDataKeeper;
  }

  void updateWorkouts(List<String> priceList) {
    this.priceList = priceList;
  }

  List<String> get priceListOfString => priceList;
}
