import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProfitData extends ChangeNotifier {
  int totalProfit = 0;
  int monthProfit = 0;
  int todayProfit = 0;

  void updateProfitData(int totalSum, int monthSum, int todaySum) {
    totalProfit = totalSum;
    monthProfit = monthSum;
    todayProfit = todaySum;
  }
}

class CalcProfitHistory {
  int totalSum;
  int monthSum;
  int todaySum;

  // Streambuilder is always called twice.
  // Because of this, values are always doubled.
  // Init data at first prevents it from this behavior.
  void initProfitData() {
    totalSum = 0;
    monthSum = 0;
    todaySum = 0;
  }

  void calcProfitDataSum(int value, DateTime timeStamp) {
    int whichYear = timeStamp.year;
    int whichMonth = timeStamp.month;
    int whichDay = timeStamp.day;
    int todayYear = DateTime.now().year;
    int todayMonth = DateTime.now().month;
    int todayDay = DateTime.now().day;

    totalSum += value;
    if (whichYear == todayYear && whichMonth == todayMonth) {
      monthSum += value;
      if (whichDay == todayDay) {
        todaySum += value;
      }
    }
  }
}
