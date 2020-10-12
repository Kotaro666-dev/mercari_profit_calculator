import 'package:flutter/foundation.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';

class AddData extends ChangeNotifier {
  String itemTitle = "";
  double soldPrice = 0;
  double shippingFee = 0;
  String otherFeeTemp = kOtherFee;
  double profit = 0;

  void initInputInfo() {
    itemTitle = "";
    soldPrice = 0;
    shippingFee = 0;
  }
}
