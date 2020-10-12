import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class AlertDialogWithTwoChoices extends StatelessWidget {
  const AlertDialogWithTwoChoices({
    Key key,
    @required this.itemName,
    @required FirebaseFirestore firestore,
    @required this.createdAt,
  })  : _firestore = firestore,
        super(key: key);

  final String itemName;
  final FirebaseFirestore _firestore;
  final createdAt;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        'Delete "$itemName"?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
          "This profit record will be permanently deleted from Profit History."),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            "CANCEL",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          child: Text(
            "DELETE",
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          onPressed: () async {
            _firestore
                .collection('test_user')
                .where("createdAt", isEqualTo: createdAt)
                .get()
                .then((snapshot) {
              snapshot.docs.first.reference.delete();
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
