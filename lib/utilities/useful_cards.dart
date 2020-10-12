import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

String convertNumWithDot(int num) {
  FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: num.toDouble());
  return (fmf.output.withoutFractionDigits);
}

class ProfitCard extends StatelessWidget {
  final String title;
  final Color color;
  final int profit;

  ProfitCard({this.title, this.color, this.profit});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.mPLUSRounded1c(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  "¥" + convertNumWithDot(profit),
                  style: GoogleFonts.mPLUSRounded1c(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    textStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddItemTextCard extends StatelessWidget {
  final String title;
  AddItemTextCard({this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: GoogleFonts.mPLUSRounded1c(
        fontSize: 16.0,
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
