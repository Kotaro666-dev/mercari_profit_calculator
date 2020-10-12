import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercari_profit_calculator/views/profit_screen.dart';
import 'package:mercari_profit_calculator/utilities/constants.dart';
import 'package:mercari_profit_calculator/views/other_shipping_screen.dart';
import 'package:mercari_profit_calculator/utilities/textfield_library.dart';
import 'package:provider/provider.dart';
import 'package:mercari_profit_calculator/models/shipping_btn_action.dart';
import 'package:mercari_profit_calculator/utilities/useful_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mercari_profit_calculator/utilities/alert_dialog_library.dart';

String itemName = "";
double soldPrice = 0;
double profit = 0;

void initInputInfo() {
  itemName = "";
  soldPrice = 0;
}

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ShippingBtnEventHandler shipBtnEventHandler =
      new ShippingBtnEventHandler();
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    shipBtnEventHandler.initButton();
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
                      ShippingFeeCard(
                        price: kRakuRakuFee,
                        textColor: shipBtnEventHandler.rakuRakuTextColor,
                        bgColor: shipBtnEventHandler.rakurakuBGColor,
                        changeButtonEffect: () {
                          setState(() {
                            shipBtnEventHandler.setBtnBool(kRakuRakuFee);
                            shipBtnEventHandler.updateShippingBtnStyle();
                            Provider.of<ShippingBtnEventHandler>(context,
                                    listen: false)
                                .updateOtherBtnWithStringOther();
                            shipBtnEventHandler.shippingFee =
                                double.parse(kRakuRakuFee);
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ShippingFeeCard(
                        price: kYuYuFee,
                        textColor: shipBtnEventHandler.yuyuTextColor,
                        bgColor: shipBtnEventHandler.yuyuBGColor,
                        changeButtonEffect: () {
                          setState(() {
                            shipBtnEventHandler.setBtnBool(kYuYuFee);
                            shipBtnEventHandler.updateShippingBtnStyle();
                            Provider.of<ShippingBtnEventHandler>(context,
                                    listen: false)
                                .updateOtherBtnWithStringOther();
                            shipBtnEventHandler.shippingFee =
                                double.parse(kYuYuFee);
                          });
                        },
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      ShippingFeeCard(
                        price: Provider.of<ShippingBtnEventHandler>(context)
                            .otherFeeTemp,
                        textColor: shipBtnEventHandler.otherTextColor,
                        bgColor: shipBtnEventHandler.otherBGColor,
                        changeButtonEffect: () {
                          setState(
                            () {
                              shipBtnEventHandler.setBtnBool(kOtherFee);
                              shipBtnEventHandler.updateShippingBtnStyle();
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    // child: ChooseOtherShippingScreen(),
                                    child: OtherShippingScreen(
                                        handler: shipBtnEventHandler),
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
                AddOrGoBackBtn(
                    handler: shipBtnEventHandler, firestore: _firestore),
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

  final ShippingBtnEventHandler handler;
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
              Provider.of<ShippingBtnEventHandler>(context, listen: false)
                  .updateOtherBtnWithStringOther();
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
                profit = (soldPrice * 0.9) - handler.shippingFee;
                // print(handler.shippingFee);
                _firestore.collection('test_user').add({
                  'item_name': itemName,
                  'sold_price': soldPrice,
                  'shippingFee': handler.shippingFee,
                  'profit': profit,
                  'createdAt': DateTime.now(),
                });
                handler.initButton();
                initInputInfo();
                Provider.of<ShippingBtnEventHandler>(context, listen: false)
                    .updateOtherBtnWithStringOther();
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
          style: GoogleFonts.kosugiMaru(
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
