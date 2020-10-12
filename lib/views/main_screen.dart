import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercari_profit_calculator/views/profit_screen.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:mercari_profit_calculator/utilities/useful_cards.dart';
import 'package:mercari_profit_calculator/views/add_item_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercari_profit_calculator/models/profit_data.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatelessWidget {
  static const String pageID = 'main_screen';
  final _firestore = FirebaseFirestore.instance;
  final CalcProfitHistory calcProfitHistory = new CalcProfitHistory();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: AddItemScreen(),
                  );
                });
          },
        ),
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          title: Text(
            'Mercari Profit Calculator',
            style: GoogleFonts.mPLUSRounded1c(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              textStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.listAlt),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, ProfitScreen.pageID);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 30.0,
            left: 50.0,
            right: 50.0,
            bottom: 100.0,
          ),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection(kUserID).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final items = snapshot.data.docs;
                    // Streambuilder is always called twice.
                    // Because of this, values are always doubled.
                    // Init data at first prevents it from this behavior.
                    calcProfitHistory.initProfitData();
                    for (var item in items) {
                      final profit = item.get('profit').round();
                      final timeStamp = item.get('createdAt').toDate();
                      calcProfitHistory.calcProfitDataSum(profit, timeStamp);
                    }
                  }
                  Provider.of<ProfitData>(context).updateProfitData(
                      calcProfitHistory.totalSum,
                      calcProfitHistory.monthSum,
                      calcProfitHistory.todaySum);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProfitCard(
                        title: "Total",
                        color: kTotalColor,
                        profit: calcProfitHistory.totalSum,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ProfitCard(
                        title: "Month",
                        color: kMonthColor,
                        profit: calcProfitHistory.monthSum,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ProfitCard(
                        title: "Today",
                        color: kTodayColor,
                        profit: calcProfitHistory.todaySum,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
