import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/views/add_item_screen.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:mercari_profit_calculator/utilities/textfield_library.dart';
import 'package:provider/provider.dart';
import 'package:mercari_profit_calculator/utilities/useful_cards.dart';

double shippingFeeTemp = 0.0;

class CustomizeShippingFeeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        color: kBottomSheetBGColor,
        child: Container(
          decoration: BoxDecoration(
            color: kBottomSheetFrontColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              top: 30.0,
              left: 20.0,
              right: 20.0,
              bottom: 30.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AddItemTextCard(title: 'Shipping Fee'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: ShippingFeeTextField(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ButtonTheme(
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 4.0,
                      child: Text(
                        "GO",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      color: kFourthColor,
                      onPressed: () {
                        Provider.of<OtherShippingFeeText>(context,
                                listen: false)
                            .updateOtherShippingFeeText(shippingFeeTemp);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
