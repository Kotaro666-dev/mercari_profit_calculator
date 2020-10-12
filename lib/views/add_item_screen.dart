import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/views/profit_screen.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:mercari_profit_calculator/views/customize_shipping_fee_screen.dart';
import 'package:mercari_profit_calculator/utilities/textfield_library.dart';
import 'package:provider/provider.dart';
import 'package:mercari_profit_calculator/models/shipping_btn_action.dart';
import 'package:mercari_profit_calculator/utilities/useful_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

String itemName = "";
double soldPrice = 0;
double shippingFee = 0;
double profit = 0;

void initInputInfo() {
  itemName = "";
  soldPrice = 0;
  shippingFee = 0;
}

class OtherShippingFeeText with ChangeNotifier {
  String otherFeeTemp = kOtherFee;

  void updateOtherShippingFeeText(double num) {
    shippingFee = num;
    otherFeeTemp = "$shippingFee";
    notifyListeners();
  }
}

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  ShippingBtnActionHandler handler = new ShippingBtnActionHandler();
  OtherShippingFeeText otherShippingFeeText = new OtherShippingFeeText();

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    handler.initButton();
    initInputInfo();
  }

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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
              bottom: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: AddItemTextCard(title: 'Item Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ItemNameTextField(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: AddItemTextCard(title: 'Sold Price'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SoldPriceTextField(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: AddItemTextCard(
                    title: 'Shipping Fee',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShippingCard(
                        price: kRakuRakuFee,
                        textColor: handler.rakuRakuTextColor,
                        bgColor: handler.rakurakuBGColor,
                        changeButtonEffect: () {
                          setState(() {
                            handler.setBtnBool(kRakuRakuFee);
                            handler.updateBtnStyle();
                            shippingFee = double.parse(kRakuRakuFee);
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ShippingCard(
                        price: kYuYuFee,
                        textColor: handler.yuyuTextColor,
                        bgColor: handler.yuyuBGColor,
                        changeButtonEffect: () {
                          setState(() {
                            handler.setBtnBool(kYuYuFee);
                            handler.updateBtnStyle();
                            shippingFee = double.parse(kYuYuFee);
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ShippingCard(
                        price: otherShippingFeeText.otherFeeTemp,
                        textColor: handler.otherTextColor,
                        bgColor: handler.otherBGColor,
                        changeButtonEffect: () {
                          setState(
                            () {
                              handler.setBtnBool(kOtherFee);
                              handler.updateBtnStyle();
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ChangeNotifierProvider(
                                      create: (context) =>
                                          OtherShippingFeeText(),
                                      child: CustomizeShippingFeeScreen(),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                AddOrGoBackBtn(handler: handler, firestore: _firestore),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddOrGoBackBtn extends StatelessWidget {
  const AddOrGoBackBtn({
    Key key,
    @required this.handler,
    @required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final ShippingBtnActionHandler handler;
  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AddItemActionButton(
            title: "GO BACK",
            color: kFourthColor,
            onPressed: () {
              handler.initButton();
              initInputInfo();
              Navigator.pop(context);
            },
          ),
          AddItemActionButton(
            title: "ADD",
            color: kPrimaryColor,
            onPressed: () async {
              if (itemName.length == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWithOneChoice(title: "Item Name");
                  },
                );
              } else if (soldPrice == 0) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWithOneChoice(title: "Sold Price");
                  },
                );
              } else if (handler.isRakuRakuClicked == false &&
                  handler.isYuYuClicked == false &&
                  handler.isOtherClicked == false) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialogWithOneChoice(title: "Shipping Fee");
                  },
                );
              } else {
                profit = (soldPrice * 0.9) - shippingFee;
                _firestore.collection('test_user').add({
                  'item_name': itemName,
                  'sold_price': soldPrice,
                  'shippingFee': shippingFee,
                  'profit': profit,
                  'createdAt': DateTime.now(),
                });
                handler.initButton();
                initInputInfo();
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => new ProfitScreen(),
                  ),
                );
                // Navigator.pushNamed(context, ProfitScreen.pageID);
              }
            },
          ),
        ],
      ),
    );
  }
}

class AlertDialogWithOneChoice extends StatelessWidget {
  final title;
  AlertDialogWithOneChoice({this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Error",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text("$title field is required."),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class AddItemActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Function onPressed;
  AddItemActionButton({this.title, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 50.0,
      minWidth: 100.0,
      child: RaisedButton(
        elevation: 4.0,
        child: Text(
          title,
          style: GoogleFonts.mPLUSRounded1c(
            fontSize: 18.0,
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
        ),
        color: color,
        onPressed: onPressed,
      ),
    );
  }
}

class ShippingCard extends StatefulWidget {
  String price;
  Color textColor;
  Color bgColor;
  Function changeButtonEffect;

  ShippingCard(
      {this.price, this.textColor, this.bgColor, this.changeButtonEffect});
  @override
  _ShippingCardState createState() => _ShippingCardState();
}

class _ShippingCardState extends State<ShippingCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ButtonTheme(
        height: 45.0,
        child: RaisedButton(
          child: Text(
            widget.price,
            style: GoogleFonts.mPLUSRounded1c(
              fontSize: 16.0,
              textStyle: TextStyle(
                color: widget.textColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
          ),
          color: widget.bgColor,
          // textColor: Colors.white,
          textColor: widget.textColor,
          shape: StadiumBorder(),
          onPressed: widget.changeButtonEffect,
        ),
      ),
    );
  }
}