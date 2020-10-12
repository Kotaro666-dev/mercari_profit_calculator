import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:mercari_profit_calculator/views/add_item_screen.dart';
import 'package:mercari_profit_calculator/views/other_shipping_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemNameTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextField(
        autofocus: false,
        onChanged: (newValue) {
          itemName = newValue;
        },
        keyboardType: TextInputType.text,
        textAlign: TextAlign.center,
        maxLength: 30,
        style: GoogleFonts.kosugiMaru(
          fontSize: 16.0,
          textStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        decoration: InputDecoration(
          hintText: "Kawaii item",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: kBorderColor,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: kBorderColor,
              width: 2.0,
            ),
          ),
        ),
        cursorColor: kBorderColor,
      ),
    );
  }
}

class SoldPriceTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (newValue) {
        soldPrice = double.parse(newValue);
      },
      maxLength: 7,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      textAlign: TextAlign.center,
      style: GoogleFonts.kosugiMaru(
        fontSize: 18.0,
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      decoration: InputDecoration(
        hintText: "¥0",
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 2.0,
          ),
        ),
      ),
      cursorColor: kBorderColor,
    );
  }
}

class ShippingFeeTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (newValue) {
        shippingFeeTemp = double.parse(newValue);
      },
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      textAlign: TextAlign.center,
      style: GoogleFonts.kosugiMaru(
        fontSize: 18.0,
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 4.0,
          ),
        ),
      ),
      cursorColor: kBorderColor,
    );
  }
}
