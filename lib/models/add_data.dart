import 'package:flutter/foundation.dart';

class AddData extends ChangeNotifier {
  String itemName = "";
  double soldPrice = 0;
  double profit = 0;

  void initInputInfo() {
    itemName = "";
    soldPrice = 0;
  }

  void updateItemName(String value) {
    itemName = value;
    notifyListeners();
  }

  void updateSoldPrice(double value) {
    soldPrice = value;
    notifyListeners();
  }
}
