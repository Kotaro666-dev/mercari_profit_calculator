import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';

class ShippingBtnEventHandler extends ChangeNotifier {
  double shippingFee = 0;
  String otherFeeTemp = kOtherFee;

  bool isRakuRakuClicked = false;
  bool isYuYuClicked = false;
  bool isOtherClicked = false;

  Color rakuRakuTextColor = Colors.black;
  Color rakurakuBGColor = Colors.white;
  Color yuyuTextColor = Colors.black;
  Color yuyuBGColor = Colors.white;
  Color otherTextColor = Colors.black;
  Color otherBGColor = Colors.white;

  void initButton() {
    isRakuRakuClicked = false;
    isYuYuClicked = false;
    isOtherClicked = false;
    rakuRakuTextColor = Colors.black;
    rakurakuBGColor = Colors.white;
    yuyuTextColor = Colors.black;
    yuyuBGColor = Colors.white;
    otherTextColor = Colors.black;
    otherBGColor = Colors.white;
    shippingFee = 0;
    otherFeeTemp = kOtherFee;
  }

  void setBtnBool(String target) {
    if (target == kRakuRakuFee) {
      isRakuRakuClicked = true;
      isYuYuClicked = false;
      isOtherClicked = false;
    } else if (target == kYuYuFee) {
      isRakuRakuClicked = false;
      isYuYuClicked = true;
      isOtherClicked = false;
    } else {
      isRakuRakuClicked = false;
      isYuYuClicked = false;
      isOtherClicked = true;
    }
  }

  void updateShippingBtnStyle() {
    if (isRakuRakuClicked == true) {
      rakuRakuTextColor = Colors.white;
      rakurakuBGColor = kRakuRakuColor;
      yuyuTextColor = Colors.black;
      yuyuBGColor = Colors.white;
      otherTextColor = Colors.black;
      otherBGColor = Colors.white;
    } else if (isYuYuClicked == true) {
      rakuRakuTextColor = Colors.black;
      rakurakuBGColor = Colors.white;
      yuyuTextColor = Colors.white;
      yuyuBGColor = kYuYuColor;
      otherTextColor = Colors.black;
      otherBGColor = Colors.white;
    } else {
      rakuRakuTextColor = Colors.black;
      rakurakuBGColor = Colors.white;
      yuyuTextColor = Colors.black;
      yuyuBGColor = Colors.white;
      otherTextColor = Colors.white;
      otherBGColor = kOtherColor;
    }
  }

  void updateOtherBtnWithStringOther() {
    otherFeeTemp = kOtherFee;
    notifyListeners();
  }

  void updateOtherBtnWithTypedNum(double num) {
    shippingFee = num;
    otherFeeTemp = shippingFee.round().toString();
    notifyListeners();
  }
}
