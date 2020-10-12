import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/views/main_screen.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercari_profit_calculator/models/profit_data.dart';
import 'package:mercari_profit_calculator/utilities/useful_cards.dart';
import 'package:mercari_profit_calculator/utilities/alert_dialog_library.dart';

class ProfitScreen extends StatelessWidget {
  static const String pageID = 'profit_screen';
  final _firestore = FirebaseFirestore.instance;
  final CalcProfitHistory calcProfitHistory = new CalcProfitHistory();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          "Profit History",
          style: GoogleFonts.kosugiMaru(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            textStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            iconSize: 35.0,
            onPressed: () {
              // Navigator.of(context, rootNavigator: true).push(
              //   new CupertinoPageRoute<bool>(
              //     fullscreenDialog: false,
              //     builder: (BuildContext context) => new MainScreen(),
              //   ),
              // );
              Navigator.pushNamed(context, MainScreen.pageID);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection(kUserID)
                .orderBy(
                  'createdAt',
                  descending: true,
                )
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final items = snapshot.data.docs;
                List<Widget> itemWidgets = [];
                int currentMonth;
                int currentDay;
                for (var item in items) {
                  final itemName = item.get('item_name');
                  final soldPrice = item.get('sold_price').round();
                  final profit = item.get('profit').round();
                  final timeStamp = item.get('createdAt').toDate();
                  final dateWidget = DateBox(
                    year: timeStamp.year,
                    month: timeStamp.month,
                    day: timeStamp.day,
                  );
                  final itemWidget = ItemBox(
                    itemName: itemName,
                    soldPrice: soldPrice,
                    profit: profit,
                    createdAt: Timestamp.fromDate(timeStamp),
                  );
                  if (currentMonth != timeStamp.month ||
                      currentDay != timeStamp.day) {
                    currentMonth = timeStamp.month;
                    currentDay = timeStamp.day;
                    itemWidgets.add(dateWidget);
                  }
                  itemWidgets.add(itemWidget);
                }
                return Expanded(
                  child: ListView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    children: itemWidgets,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class DateBox extends StatelessWidget {
  final year;
  final month;
  final day;

  DateBox({this.year, this.month, this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "$year年$month月$day日",
          style: GoogleFonts.kosugiMaru(
            fontSize: 18.0,
            textStyle: TextStyle(color: kThirdColor),
          ),
        ),
      ),
    );
  }
}

class ItemBox extends StatelessWidget {
  final _firestore = FirebaseFirestore.instance;

  final String itemName;
  final num soldPrice;
  final num profit;
  final createdAt;

  ItemBox({this.itemName, this.soldPrice, this.profit, this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onLongPress: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialogWithTwoChoices(
                  itemName: itemName,
                  firestore: _firestore,
                  createdAt: createdAt);
            },
          );
        },
        child: Container(
          height: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: kSecondColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: kThirdColor,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "$itemName",
                        textAlign: TextAlign.left,
                        style: GoogleFonts.kosugiMaru(
                          fontSize: 14.0,
                          textStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "¥" + convertNumWithDot(profit),
                      style: GoogleFonts.kosugiMaru(
                        fontSize: 14.0,
                        textStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
